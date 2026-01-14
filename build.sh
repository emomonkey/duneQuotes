#!/bin/bash
cat > mongoid.yml << EOF
development:
  clients:
    default:
      uri: "$MONGODB_URI"
      options:
        auth_mech: :scram
        server_selection_timeout: 5
EOF
