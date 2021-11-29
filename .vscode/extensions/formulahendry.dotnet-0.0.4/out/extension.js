"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const dotnet_1 = require("./dotnet");
const executor_1 = require("./executor");
function activate(context) {
    context.subscriptions.push(vscode.commands.registerCommand("dotnet.build", (fileUri) => {
        dotnet_1.Dotnet.build(fileUri);
    }));
    context.subscriptions.push(vscode.commands.registerCommand("dotnet.run", (fileUri) => {
        dotnet_1.Dotnet.run(fileUri);
    }));
    context.subscriptions.push(vscode.commands.registerCommand("dotnet.test", (fileUri) => {
        dotnet_1.Dotnet.test(fileUri);
    }));
    context.subscriptions.push(vscode.window.onDidCloseTerminal((closedTerminal) => {
        executor_1.Executor.onDidCloseTerminal(closedTerminal);
    }));
}
exports.activate = activate;
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map