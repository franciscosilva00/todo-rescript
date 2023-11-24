type autoAnimateOptions = {
  /*
   * The time it takes to run a single sequence of animations in milliseconds.
   */
  duration?: int,
  /*
   * The type of easing to use.
   * Default: ease-in-out
   */
  easing?: [#linear | #"ease-in" | #"ease-out" | #"ease-in-out"],
  /*
   * Ignore a user’s "reduce motion" setting and enable animations. It is not
   * recommended to use this.
   */
  disrespectUserMotionPreference?: bool,
}

@module("@formkit/auto-animate/react")
external useAutoAnimate: (
  ~config: autoAnimateOptions=?,
) => (ReactDOM.Ref.currentDomRef, bool => unit) = "useAutoAnimate"
