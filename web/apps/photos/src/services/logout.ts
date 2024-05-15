import log from "@/next/log";
import { accountLogout } from "@ente/accounts/services/logout";
import { Events, eventBus } from "@ente/shared/events";
import { clipService } from "services/clip-service";
import mlWorkManager from "./machineLearning/mlWorkManager";

/**
 * Logout sequence for the photos app.
 *
 * This function is guaranteed not to throw any errors.
 *
 * See: [Note: Do not throw during logout].
 */
export const photosLogout = async () => {
    await accountLogout();

    try {
        await clipService.logout();
    } catch (e) {
        log.error("Ignoring error in CLIP logout", e);
    }

    try {
        await mlWorkManager.setMlSearchEnabled(false);
    } catch (e) {
        log.error("Ignoring error in ML logout", e);
    }

    const electron = globalThis.electron;
    if (electron) {
        try {
            await electron?.logout();
        } catch (e) {
            log.error("Ignoring error in native side logout sequence", e);
        }
    }

    try {
        eventBus.emit(Events.LOGOUT);
    } catch (e) {
        log.error("Ignoring error in event-bus logout handlers", e);
    }
};
