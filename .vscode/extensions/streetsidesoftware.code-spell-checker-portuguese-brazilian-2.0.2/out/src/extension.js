"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const locale = 'pt,pt_BR';
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    const vscodeSpellCheckerExtension = 'streetsidesoftware.code-spell-checker';
    const configLocation = context.asAbsolutePath('./cspell-ext.json');
    const extension = vscode.extensions.getExtension(vscodeSpellCheckerExtension);
    if (extension) {
        extension.activate().then((ext) => {
            var _a;
            // We need to register the dictionary configuration with the Code Spell Checker Extension
            (_a = ext === null || ext === void 0 ? void 0 : ext.registerConfig) === null || _a === void 0 ? void 0 : _a.call(ext, configLocation);
        });
    }
    function enable(isGlobal) {
        extension &&
            extension.activate().then((ext) => {
                var _a;
                (_a = ext === null || ext === void 0 ? void 0 : ext.enableLocal) === null || _a === void 0 ? void 0 : _a.call(ext, isGlobal, locale);
            });
    }
    function disable(isGlobal) {
        extension &&
            extension.activate().then((ext) => {
                var _a;
                (_a = ext === null || ext === void 0 ? void 0 : ext.disableLocal) === null || _a === void 0 ? void 0 : _a.call(ext, isGlobal, locale);
            });
    }
    // Push the disposable to the context's subscriptions so that the
    // client can be deactivated on extension deactivation
    context.subscriptions.push(vscode.commands.registerCommand('cSpellExt_portuguese-brazilian.enablePortuguese_brazilian', () => enable(true)), vscode.commands.registerCommand('cSpellExt_portuguese-brazilian.disablePortuguese_brazilian', () => disable(true)), vscode.commands.registerCommand('cSpellExt_portuguese-brazilian.enablePortuguese_brazilianWorkspace', () => enable(false)), vscode.commands.registerCommand('cSpellExt_portuguese-brazilian.disablePortuguese_brazilianWorkspace', () => disable(false)));
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map