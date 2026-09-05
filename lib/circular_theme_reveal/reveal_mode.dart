/// Defines how the circular animation unfolds between theme changes.
enum RevealMode {
  /// Light -> Dark expands OUTward, Dark -> Light collapses INward.
  expandAndCollapse,

  /// Both Light -> Dark and Dark -> Light expand OUTward.
  alwaysExpandOut,

  /// Both Light -> Dark and Dark -> Light collapse INward.
  alwaysCollapseIn,
}
