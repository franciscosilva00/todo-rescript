@react.component
let make = (
  ~todos: Belt.Array.t<TodoForm.todo>,
  ~onRemove: TodoForm.todo => unit,
  ~onToggle: TodoForm.todo => unit,
) => {
  todos
  ->Array.map(thisTodo =>
    <li
      key={thisTodo.id} className="flex justify-between items-center border-b border-gray-200 py-4">
      <h2
        className="list-none hover:opacity-80 hover:line-through hover:cursor-pointer hover:text-rose-600"
        onClick={_ => onRemove(thisTodo)}>
        {thisTodo.text->React.string}
      </h2>
      <input
        type_="checkbox"
        className="accent-rose-500"
        checked={thisTodo.completed}
        onChange={_ => onToggle(thisTodo)}
      />
    </li>
  )
  ->React.array
}
