#!/usr/bin/env python3

import firebase_admin
from firebase_admin import credentials, firestore
from typing import Dict, List, Any, Optional
import json
from datetime import datetime
import argparse
import os
from pathlib import Path

class FirebaseReader:
    def __init__(self, credentials_path: str):
        """
        Initialize Firebase connection with service account credentials.
        
        Args:
            credentials_path (str): Path to the Firebase service account JSON file
        """
        try:
            if not os.path.exists(credentials_path):
                raise FileNotFoundError(f"Credentials file not found: {credentials_path}")
                
            cred = credentials.Certificate(credentials_path)
            firebase_admin.initialize_app(cred)
            self.db = firestore.client()
            print("✅ Successfully connected to Firebase")
        except Exception as e:
            print(f"❌ Error initializing Firebase: {str(e)}")
            raise

    def read_collection(self, collection_name: str, limit: Optional[int] = None, where_clause: Optional[Dict] = None) -> List[Dict[str, Any]]:
        """
        Read documents from a specified collection.
        
        Args:
            collection_name (str): Name of the collection to read
            limit (Optional[int]): Maximum number of documents to read
            where_clause (Optional[Dict]): Dictionary containing field, operator, and value for filtering
            
        Returns:
            List[Dict[str, Any]]: List of documents in the collection
        """
        try:
            query = self.db.collection(collection_name)
            
            # Apply where clause if provided
            if where_clause:
                query = query.where(
                    where_clause['field'],
                    where_clause['operator'],
                    where_clause['value']
                )
            
            if limit:
                query = query.limit(limit)
                
            docs = query.stream()
            results = []
            for doc in docs:
                data = doc.to_dict()
                data['id'] = doc.id
                # Convert Firestore Timestamps to datetime
                for key, value in data.items():
                    if hasattr(value, 'timestamp'):
                        data[key] = datetime.fromtimestamp(value.timestamp())
                results.append(data)
            return results
        except Exception as e:
            print(f"❌ Error reading collection {collection_name}: {str(e)}")
            return []

    def read_user(self, user_id: str) -> Optional[Dict[str, Any]]:
        """
        Read a specific user document.
        
        Args:
            user_id (str): ID of the user to read
            
        Returns:
            Optional[Dict[str, Any]]: User document if found, None otherwise
        """
        try:
            doc = self.db.collection('users').document(user_id).get()
            if doc.exists:
                data = doc.to_dict()
                data['id'] = doc.id
                return data
            return None
        except Exception as e:
            print(f"❌ Error reading user {user_id}: {str(e)}")
            return None

    def read_project(self, project_id: str) -> Optional[Dict[str, Any]]:
        """
        Read a specific project document.
        
        Args:
            project_id (str): ID of the project to read
            
        Returns:
            Optional[Dict[str, Any]]: Project document if found, None otherwise
        """
        try:
            doc = self.db.collection('projects').document(project_id).get()
            if doc.exists:
                data = doc.to_dict()
                data['id'] = doc.id
                return data
            return None
        except Exception as e:
            print(f"❌ Error reading project {project_id}: {str(e)}")
            return None

    def read_bill_of_materials(self, bom_id: str) -> Optional[Dict[str, Any]]:
        """
        Read a specific bill of materials document.
        
        Args:
            bom_id (str): ID of the BOM to read
            
        Returns:
            Optional[Dict[str, Any]]: BOM document if found, None otherwise
        """
        try:
            doc = self.db.collection('billOfMaterials').document(bom_id).get()
            if doc.exists:
                data = doc.to_dict()
                data['id'] = doc.id
                return data
            return None
        except Exception as e:
            print(f"❌ Error reading BOM {bom_id}: {str(e)}")
            return None

    def read_movements(self, project_id: Optional[str] = None, material_id: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Read movement documents with optional filtering.
        
        Args:
            project_id (Optional[str]): Filter by project ID
            material_id (Optional[str]): Filter by material ID
            
        Returns:
            List[Dict[str, Any]]: List of movement documents
        """
        try:
            query = self.db.collection('movements')
            
            if project_id:
                query = query.where('projectId', '==', project_id)
            if material_id:
                query = query.where('materialId', '==', material_id)
                
            docs = query.stream()
            results = []
            for doc in docs:
                data = doc.to_dict()
                data['id'] = doc.id
                # Convert Firestore Timestamps to datetime
                for key, value in data.items():
                    if hasattr(value, 'timestamp'):
                        data[key] = datetime.fromtimestamp(value.timestamp())
                results.append(data)
            return results
        except Exception as e:
            print(f"❌ Error reading movements: {str(e)}")
            return []

    def save_to_json(self, data: List[Dict[str, Any]], filename: str):
        """
        Save the collection data to a JSON file.
        
        Args:
            data (List[Dict[str, Any]]): Collection data to save
            filename (str): Output filename
        """
        try:
            # Create output directory if it doesn't exist
            output_dir = Path('firebase_exports')
            output_dir.mkdir(exist_ok=True)
            
            filepath = output_dir / filename
            
            # Convert any datetime objects to ISO format strings
            def datetime_handler(obj):
                if isinstance(obj, datetime):
                    return obj.isoformat()
                return str(obj)

            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(data, f, default=datetime_handler, indent=2, ensure_ascii=False)
            print(f"✅ Successfully saved data to {filepath}")
        except Exception as e:
            print(f"❌ Error saving to JSON: {str(e)}")

def main():
    parser = argparse.ArgumentParser(description='Read Firebase collections for Abiezer CMS')
    parser.add_argument('--creds', required=True, help='Path to Firebase service account credentials JSON file')
    parser.add_argument('--collection', help='Specific collection to read (users, projects, billOfMaterials, movements)')
    parser.add_argument('--id', help='Specific document ID to read')
    parser.add_argument('--limit', type=int, help='Limit the number of documents to read')
    parser.add_argument('--project-id', help='Filter movements by project ID')
    parser.add_argument('--material-id', help='Filter movements by material ID')
    args = parser.parse_args()

    # Initialize Firebase reader
    reader = FirebaseReader(args.creds)
    
    # Handle specific document ID
    if args.id:
        if args.collection == 'users':
            data = reader.read_user(args.id)
            if data:
                reader.save_to_json([data], f"user_{args.id}.json")
            else:
                print(f"❌ User {args.id} not found")
        elif args.collection == 'projects':
            data = reader.read_project(args.id)
            if data:
                reader.save_to_json([data], f"project_{args.id}.json")
            else:
                print(f"❌ Project {args.id} not found")
        elif args.collection == 'billOfMaterials':
            data = reader.read_bill_of_materials(args.id)
            if data:
                reader.save_to_json([data], f"bom_{args.id}.json")
            else:
                print(f"❌ BOM {args.id} not found")
        return

    # Collections to read
    collections = ['users', 'projects', 'billOfMaterials', 'movements']
    
    if args.collection:
        if args.collection not in collections:
            print(f"⚠️ Warning: {args.collection} is not in the standard collections list")
        collections = [args.collection]

    # Read each collection and save to JSON
    for collection in collections:
        print(f"\n📚 Reading collection: {collection}")
        
        if collection == 'movements':
            data = reader.read_movements(args.project_id, args.material_id)
        else:
            data = reader.read_collection(collection, args.limit)
            
        print(f"📝 Found {len(data)} documents")
        
        # Save to JSON file
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{collection}_{timestamp}.json"
        reader.save_to_json(data, filename)

if __name__ == "__main__":
    main() 