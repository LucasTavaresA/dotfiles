"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const appInsights = require("applicationinsights");
const utility_1 = require("./utility");
class AppInsightsClient {
    static sendEvent(eventName, properties) {
        if (this._enableTelemetry) {
            this._client.trackEvent({ name: eventName, properties });
        }
    }
}
AppInsightsClient._client = new appInsights.TelemetryClient("2bfdfc27-d05c-4d8e-b628-4b0dc7b9a67e");
AppInsightsClient._enableTelemetry = utility_1.Utility.getConfiguration().get("enableTelemetry");
exports.AppInsightsClient = AppInsightsClient;
//# sourceMappingURL=appInsightsClient.js.map