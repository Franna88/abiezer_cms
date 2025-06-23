#!/bin/bash

# Deploy Firebase Storage Rules Script
# This script deploys the updated storage.rules file to Firebase

echo "🔥 Deploying Firebase Storage Security Rules..."
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo "Please install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if storage.rules file exists
if [ ! -f "storage.rules" ]; then
    echo "❌ storage.rules file not found in current directory"
    exit 1
fi

echo "📋 Current storage.rules summary:"
echo "   - Added usage photos security rules"
echo "   - Added request photos security rules"
echo "   - Added project documents security rules"
echo "   - Added project images security rules"
echo "   - Added user uploads security rules"
echo ""

# Deploy the rules
echo "🚀 Deploying Storage rules to Firebase..."
firebase deploy --only storage

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Firebase Storage security rules deployed successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Test image uploads in your app"
    echo "   2. Test document uploads in your app"
    echo "   3. Verify proper access controls are working"
    echo ""
    echo "💡 Pro tip: You can deploy both Firestore and Storage rules together with:"
    echo "   firebase deploy --only firestore:rules,storage"
else
    echo ""
    echo "❌ Failed to deploy Storage rules"
    echo "Please check your Firebase configuration and try again"
    exit 1
fi 