@@warning("-44")
open Belt

type todo = TodoForm.todo

let initState: array<todo> = []

@react.component
let make = () => {
  let (todos, setTodos) = React.useState(_ => initState)

  module StateUpdates = {
    let toggleCompleteTodo = (this: todo) =>
      setTodos(todos =>
        todos->Array.map(that =>
          if this.id == that.id {
            {...that, completed: !that.completed}
          } else {
            that
          }
        )
      )

    let removeTodo = thisTodo =>
      setTodos(todos => todos->Array.keep(todo => todo.id !== thisTodo.TodoForm.id))

    let clearTodos = _ => setTodos(_ => [])

    let addTodo = todo => setTodos(_ => Array.concat(todos, [todo]))
  }

  let (animatedListRef, _) = AutoAnimate.useAutoAnimate(
    ~config={
      duration: 200,
    },
  )

  // Display page
  <div className="container mx-auto p-16">
    <div className="w-full flex justify-between items-center">
      <h1 className="text-3xl font-medium mb-8"> {React.string("Your todos.")} </h1>
      <button
        onClick={_ => StateUpdates.clearTodos()}
        disabled={todos->Array.length == 0}
        className="disabled:opacity-30 transition-opacity duration-200 ease-in-out">
        {"Delete all todos 🚮"->React.string}
      </button>
    </div>
    // Display todo list
    <ul ref={ReactDOM.Ref.domRef(animatedListRef)}>
      {if Array.length(todos) == 0 {
        React.string("No todos yet!")
      } else {
        <TodoList
          todos onRemove={StateUpdates.removeTodo} onToggle={StateUpdates.toggleCompleteTodo}
        />
      }}
    </ul>
    // Display todo form
    <TodoForm onSubmit={StateUpdates.addTodo} />
  </div>
}
