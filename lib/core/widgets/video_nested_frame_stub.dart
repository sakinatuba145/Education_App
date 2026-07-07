/// Non-web platforms (Android/iOS/desktop) are never rendered inside a
/// browser iframe, so there is no "nested iframe" restriction to worry
/// about here — always returns false.
bool isRunningInNestedIframe() => false;
