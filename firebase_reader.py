#!/usr/bin/env python3

import firebase_admin
from firebase_admin import credentials, firestore
from typing import Dict, List, Any
import json
from datetime import datetime
import argparse

class FirebaseReader:
    def __init__(self, credentials_path: str):
        """
        Initialize Firebase connection with service account credentials.
        
        Args:
            credentials_path (str): Path to the Firebase service account JSON file
        """
        try:
            cred = credentials.Certificate(credentials_path)
            firebase_admin.initialize_app(cred)
            self.db = firestore.client()
            print("✅ Successfully connected to Firebase")
        except Exception as e:
            print(f"❌ Error initializing Firebase: {str(e)}")
            raise

    def read_collection(self, collection_name: str) -> List[Dict[str, Any]]:
        """
        Read all documents from a specified collection.
        
        Args:
            collection_name (str): Name of the collection to read
            
        Returns:
            List[Dict[str, Any]]: List of documents in the collection
        """
        try:
            docs = self.db.collection(collection_name).stream()
            results = []
            for doc in docs:
                data = doc.to_dict()
                data['id'] = doc.id
                results.append(data)
            return results
        except Exception as e:
            print(f"❌ Error reading collection {collection_name}: {str(e)}")
            return []

    def save_to_json(self, data: List[Dict[str, Any]], filename: str):
        """
        Save the collection data to a JSON file.
        
        Args:
            data (List[Dict[str, Any]]): Collection data to save
            filename (str): Output filename
        """
        try:
            # Convert any datetime objects to ISO format strings
            def datetime_handler(obj):
                if isinstance(obj, datetime):
                    return obj.isoformat()
                return str(obj)

            with open(filename, 'w', encoding='utf-8') as f:
                json.dump(data, f, default=datetime_handler, indent=2, ensure_ascii=False)
            print(f"✅ Successfully saved data to {filename}")
        except Exception as e:
            print(f"❌ Error saving to JSON: {str(e)}")

def main():
    parser = argparse.ArgumentParser(description='Read Firebase collections for Abiezer CMS')
    parser.add_argument('--creds', required=True, help='Path to Firebase service account credentials JSON file')
    parser.add_argument('--collection', help='Specific collection to read (optional)')
    args = parser.parse_args()

    # Initialize Firebase reader
    reader = FirebaseReader(args.creds)
    
    # Collections to read
    collections = ['users', 'materials', 'projects', 'audit_log']
    
    if args.collection:
        if args.collection not in collections:
            print(f"⚠️ Warning: {args.collection} is not in the standard collections list")
        collections = [args.collection]

    # Read each collection and save to JSON
    for collection in collections:
        print(f"\n📚 Reading collection: {collection}")
        data = reader.read_collection(collection)
        print(f"📝 Found {len(data)} documents")
        
        # Save to JSON file
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{collection}_{timestamp}.json"
        reader.save_to_json(data, filename)

if __name__ == "__main__":
    main() 