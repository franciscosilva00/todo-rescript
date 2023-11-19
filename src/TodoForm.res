@send external focus: Dom.element => unit = "focus"

type todo = {id: string, text: string, completed: bool}

let getRandomId = _ => Js.Math.random()->Belt.Float.toString

@react.component
let make = (~onSubmit: todo => unit) => {
  // Focus the input when the component is rerendering
  // In case the user clicks the button instead of pressing
  // enter to submit the form
  module InputFocus = {
    let textInput = React.useRef(Js.Nullable.null)

    let focusInput = () =>
      switch textInput.current->Js.Nullable.toOption {
      | Some(dom) => dom->focus
      | None => ()
      }

    React.useEffect(() => {Some(_ => focusInput())})
  }

  let (currTodo, setCurrTodo) = React.useState(() => {
    id: getRandomId(),
    text: "",
    completed: false,
  })

  module StateUpdates = {
    let clearState = _ =>
      setCurrTodo(_ => {
        id: getRandomId(),
        text: "",
        completed: false,
      })

    let onChange = event => {
      let text = ReactEvent.Form.currentTarget(event)["value"]

      setCurrTodo(todo => {
        ...todo,
        text,
      })
    }

    let onSubmit = event => {
      ReactEvent.Form.preventDefault(event)

      let text = String.trim(currTodo.text)

      if String.length(text) > 3 {
        onSubmit({
          ...currTodo,
          text,
        })

        clearState()
      }
    }
  }

  <form onSubmit={StateUpdates.onSubmit} className="flex items-center gap-4 my-8 float-right">
    <input
      onChange={StateUpdates.onChange}
      value={currTodo.text}
      ref={ReactDOM.Ref.domRef(InputFocus.textInput)}
      autoFocus=true
      className="px-3 py-1.5 rounded focus:border-rose-500 outline-none border-2"
      type_="text"
    />
    <button className="bg-rose-500 px-6 py-1.5 rounded text-white " type_="submit">
      {"Add todo ✨"->React.string}
    </button>
  </form>
}
