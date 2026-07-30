// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/ai;

# The database row shape for a persisted approval checkpoint.
type CheckpointRecord record {|
    # The serialized `ai:PendingApproval` as a JSON string
    string CheckpointJson;
|};

# Serializes a pending approval to the JSON string persisted in the checkpoint table. Delegates to
# the ai module's canonical serialization so every store persists checkpoints identically and does
# not reimplement the (non-trivial) handling of `Prompt` content and `Error` outputs.
#
# + approval - The pending approval to serialize
# + return - The JSON string, or an `Error` if it could not be serialized
isolated function serializeCheckpoint(ai:PendingApproval approval) returns string|Error {
    string|ai:Error serialized = ai:serializePendingApproval(approval);
    if serialized is ai:Error {
        return error("Failed to serialize approval checkpoint: " + serialized.message(), serialized);
    }
    return serialized;
}

# Reconstructs a pending approval from its persisted JSON string, delegating to the ai module.
#
# + checkpointJson - The serialized `ai:PendingApproval`
# + return - The reconstructed pending approval, or an `Error` if the document could not be parsed
isolated function deserializeCheckpoint(string checkpointJson) returns ai:PendingApproval|Error {
    ai:PendingApproval|ai:Error restored = ai:deserializePendingApproval(checkpointJson);
    if restored is ai:Error {
        return error("Failed to parse approval checkpoint: " + restored.message(), restored);
    }
    return restored;
}
