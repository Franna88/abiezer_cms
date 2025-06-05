import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin
cred = credentials.Certificate('path/to/your/serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

# Define the indexes we need to create
indexes = [
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
    {
        "collectionGroup": "billOfMaterials",
        "queryScope": "COLLECTION",
        "fields": [
            {"fieldPath": "status", "order": "ASCENDING"},
            {"fieldPath": "updatedAt", "order": "DESCENDING"}
        ]
    }
]

def create_indexes():
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
                print(f"Successfully created index for fields: {field_paths}")
            else:
                print(f"Index already exists for fields: {field_paths}")
                
    except Exception as e:
        print(f"Error creating indexes: {str(e)}")

if __name__ == "__main__":
    create_indexes() 