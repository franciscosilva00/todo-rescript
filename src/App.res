@@warning("-44")
open Belt

@module("@formkit/auto-animate/react")
external useAutoAnimate: unit => (ReactDOM.Ref.currentDomRef, bool => unit) = "useAutoAnimate"

@react.component
let make = () => {
  let (todos, setTodos) = React.useState(_ => [])
  let (animatedListRef, _) = useAutoAnimate()

  module StateUpdates = {
    let toggleCompleteTodo = thisTodo =>
      setTodos(todos =>
        todos->Array.map(todo =>
          if thisTodo.TodoForm.id == todo.TodoForm.id {
            {...todo, completed: !todo.completed}
          } else {
            todo
          }
        )
      )

    let removeTodo = thisTodo =>
      setTodos(todos => todos->Array.keep(todo => todo.id !== thisTodo.TodoForm.id))

    let clearTodos = _ => setTodos(_ => [])
  }

  let todoList =
    todos
    ->Array.mapWithIndex(i, thisTodo => {
      <li
        key={Int.toString(i)}
        className="flex justify-between items-center border-b border-gray-200 py-4">
        <h2
          className="list-none hover:opacity-80 hover:line-through hover:cursor-pointer hover:text-rose-600"
          onClick={_ => StateUpdates.removeTodo(thisTodo)}>
          {thisTodo.text->React.string}
        </h2>
        <input
          type_="checkbox"
          className="accent-rose-500"
          checked={thisTodo.completed}
          onChange={_ => StateUpdates.toggleCompleteTodo(thisTodo)}
        />
      </li>
    })
    ->React.array

  // Display page
  <div className="container mx-auto p-16">
    <div className="w-full flex justify-between items-center">
      <h1 className="text-3xl font-medium mb-8"> {React.string("Your todos.")} </h1>
      <button
        onClick={_ => StateUpdates.clearTodos()}
        disabled={Array.length(todos) == 0}
        className="disabled:opacity-30 transition-opacity duration-200 ease-in-out">
        {"Delete all todos 🚮"->React.string}
      </button>
    </div>
    // Display todo list
    <ul ref={ReactDOM.Ref.domRef(animatedListRef)}>
      {switch Array.length(todos) {
      | 0 => React.string("No todos yet!")
      | _ => todoList
      }}
    </ul>
    // Display todo form
    <TodoForm
      onSubmit={todo => {
        setTodos(_ => Array.concat(todos, [todo]))
      }}
    />
  </div>
}
