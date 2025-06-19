#!/usr/bin/env python3

import firebase_admin
from firebase_admin import credentials, firestore
import argparse
import os

def initialize_firebase(credentials_path: str):
    """
    Initialize Firebase Admin with service account credentials.
    
    Args:
        credentials_path (str): Path to the Firebase service account JSON file
    """
    if not os.path.exists(credentials_path):
        raise FileNotFoundError(f"Credentials file not found: {credentials_path}")
        
    cred = credentials.Certificate(credentials_path)
    firebase_admin.initialize_app(cred)
    return firestore.client()

# Define the indexes we need to create
indexes = [
    # Movements collection indexes
    {
        "collectionGroup": "movements",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "projectId", "order": "ASCENDING"},
            {"fieldPath": "timestamp", "order": "DESCENDING"}
        ]
    },
    {
        "collectionGroup": "movements",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "materialId", "order": "ASCENDING"},
            {"fieldPath": "timestamp", "order": "DESCENDING"}
        ]
    },
    {
        "collectionGroup": "movements",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "performedBy", "order": "ASCENDING"},
            {"fieldPath": "timestamp", "order": "DESCENDING"}
        ]
    },
    # Bill of Materials collection indexes
    {
        "collectionGroup": "billOfMaterials",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "status", "order": "ASCENDING"},
            {"fieldPath": "updatedAt", "order": "DESCENDING"}
        ]
    },
    {
        "collectionGroup": "billOfMaterials",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "projectId", "order": "ASCENDING"},
            {"fieldPath": "createdAt", "order": "DESCENDING"}
        ]
    },
    # Projects collection indexes
    {
        "collectionGroup": "projects",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "status", "order": "ASCENDING"},
            {"fieldPath": "updatedAt", "order": "DESCENDING"}
        ]
    },
    {
        "collectionGroup": "projects",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "managerId", "order": "ASCENDING"},
            {"fieldPath": "createdAt", "order": "DESCENDING"}
        ]
    },
    # Users collection indexes
    {
        "collectionGroup": "users",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "role", "order": "ASCENDING"},
            {"fieldPath": "createdAt", "order": "DESCENDING"}
        ]
    },
    {
        "collectionGroup": "users",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "email", "order": "ASCENDING"}
        ]
    }
]

def create_indexes(db):
    """
    Create the defined indexes in Firebase.
    
    Args:
        db: Firestore client instance
    """
    try:
        # Get the current indexes
        current_indexes = db.collection('_indexes').get()
        existing_indexes = set()
        
        for index in current_indexes:
            fields = index.get('fields', [])
            field_paths = tuple(f['fieldPath'] for f in fields)
            existing_indexes.add(field_paths)
        
        # Create new indexes
        for index in indexes:
            fields = index['fields']
            field_paths = tuple(f['fieldPath'] for f in fields)
            
            if field_paths not in existing_indexes:
                print(f"Creating index for fields: {field_paths}")
                db.collection('_indexes').add(index)
                print(f"✅ Successfully created index for fields: {field_paths}")
            else:
                print(f"ℹ️ Index already exists for fields: {field_paths}")
                
    except Exception as e:
        print(f"❌ Error creating indexes: {str(e)}")

def main():
    parser = argparse.ArgumentParser(description='Create Firebase indexes for Abiezer CMS')
    parser.add_argument('--creds', required=True, help='Path to Firebase service account credentials JSON file')
    args = parser.parse_args()

    try:
        # Initialize Firebase
        db = initialize_firebase(args.creds)
        print("✅ Successfully connected to Firebase")
        
        # Create indexes
        create_indexes(db)
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    main() 