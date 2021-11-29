"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const appInsightsClient_1 = require("./appInsightsClient");
const executor_1 = require("./executor");
class Dotnet {
    static build(fileUri) {
        if (fileUri && fileUri.fsPath) {
            executor_1.Executor.runInTerminal(`dotnet build "${fileUri.fsPath}"`);
            appInsightsClient_1.AppInsightsClient.sendEvent("build", { fileExtension: path.extname(fileUri.fsPath) });
        }
    }
    static run(fileUri) {
        if (fileUri && fileUri.fsPath) {
            executor_1.Executor.runInTerminal(`dotnet run --project "${fileUri.fsPath}"`);
            appInsightsClient_1.AppInsightsClient.sendEvent("run", { fileExtension: path.extname(fileUri.fsPath) });
        }
    }
    static test(fileUri) {
        if (fileUri && fileUri.fsPath) {
            executor_1.Executor.runInTerminal(`dotnet test "${fileUri.fsPath}"`);
            appInsightsClient_1.AppInsightsClient.sendEvent("test", { fileExtension: path.extname(fileUri.fsPath) });
        }
    }
}
exports.Dotnet = Dotnet;
//# sourceMappingURL=dotnet.js.map