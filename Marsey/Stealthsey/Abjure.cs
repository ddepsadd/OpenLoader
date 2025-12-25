using Marsey.Config;
using Marsey.Misc;

namespace Marsey.Stealthsey;

public static class Abjure
{
    private static Version? engineVer { get; set; }

    /// <summary>
    /// Checks against version with detection methods
    /// </summary>
    /// <returns>True if version is equal or over with detection and hidesey is disabled</returns>
    public static bool CheckMalbox(string engineversion, HideLevel MarseyHide)
    {
        engineversion = engineversion.Split('-')[0];

        if (!Version.TryParse(engineversion, out var v))
        {
            MarseyLogger.Log(MarseyLogger.LogType.ERRO, $"Incorrect version format: {engineversion}");
            return false;
        }

        return engineVer >= MarseyVars.Detection && MarseyHide == HideLevel.Disabled;
    }
}
