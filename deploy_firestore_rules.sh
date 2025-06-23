#!/bin/bash

# Deploy Firestore Rules Script
# This script deploys the updated firestore.rules file to Firebase

echo "🔥 Deploying Firestore Security Rules..."
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo "Please install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if firestore.rules file exists
if [ ! -f "firestore.rules" ]; then
    echo "❌ firestore.rules file not found in current directory"
    exit 1
fi

echo "📋 Current firestore.rules summary:"
echo "   - Added project_activities collection security rules"
echo "   - Added documents subcollection security rules"
echo "   - Fixed permission denied errors"
echo ""

# Deploy the rules
echo "🚀 Deploying rules to Firebase..."
firebase deploy --only firestore:rules

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Firestore security rules deployed successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Create Firestore indexes by running:"
    echo "      python3 create_indexes.py --creds path/to/service-account.json"
    echo "   2. Test project creation with image upload"
    echo "   3. Verify project activities and documents load properly"
else
    echo ""
    echo "❌ Failed to deploy Firestore rules"
    echo "Please check your Firebase configuration and try again"
    exit 1
fi 