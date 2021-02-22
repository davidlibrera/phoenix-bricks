defmodule PhoenixBricks do
  @moduledoc ~S"""
  Un opinabile set di patters proposti per uniformare parti ripetibili e riusabili
  di un Context.

  ## Motivazione
  Venendo da molti anni di sviluppo con [Ruby on Rails](https://rubyonrails.org/)
  mi sono abituato ad avere una ampia strutturazione del codice seguendo il
  Principio di Singola Responsabilità.

  [Phoenix](https://www.phoenixframework.org/) porta con se il concetto di
  [Context](https://hexdocs.pm/phoenix/contexts.html), un modulo che si occupa di
  esporre l'API di una sezione dell'applicazione alle altre sezioni dell'
  applicazione stessa.

  In un `Context` abbiamo solitamente almeno 6 funzioni per ogni `schema`
  (`list_records/0`, `get_record!/1`, `create_record/1`, `update_record/2`,
  `delete_record/1`, `change_record/2`).

  Considerando che tutta la Business Logic va a finire dentro al `Context`, è
  abbastanza semplice ritrovarsi tra le mani un modulo di centianaia di righe di
  codice, rendendone difficile la manutenzione nel lungo periodo.

  L'idea è di evidenziare delle parti a comune che possono essere riutilizzate
  su più `Context/schema` e spostarne la logica in moduli separati.

  ## List records
  Il metodo `list_*` ha un'implementazione default standard che restituisce
  la lista di record associati

  ```elixir
  def list_records do
    MyApp.Context.RecordSchema
    |> MyApp.Repo.all()
  end
  ```

  Supponendo adesso di voler fornire all'esterno del `Context` la possibilità di
  filtrare i risultati sulla base di un set arbitrario di `scopes`, si potrebbe
  pensare di definire una versione del metodo che supporta un elenco di filtri
  applicabili tramite una chiamata tipo

  ```elixir
  iex> Context.list_records(title_matches: "value")
  ```

  Una possibile idea è quella di delegare la costruzione del query ad un modulo
  separato che chiameremo `RecordQuery`:

  ```elixir
  defmodule RecordQuery do
    def scope(list_of_filters) do
      RecordSchema
      |> improve_query_with_filters(list_of_filters)
    end

    defp improve_query_with_filters(start_query, list_of_filters) do
      list_of_filters
      |> Enum.reduce(start_query, fn scope, query -> apply_scope(query, scope) end)
    end

    defp apply_scope(query, {:title_matches, "value"}) do
      query
      |> where([q], ...)
    end

    defp apply_scope(query, {:price_lte, 42}) do
      query
      |> where([q], ...)
    end
  end
  ```

  ed utilizzare questo modulo nel `Context`
  ```elixir
  def list_records(scopes \\ []) do
    RecordQuery.scope(scopes)
    |> Repo.all()
  end
  ```

  ### modulo `PhoenixBricks.Scopes`
  Usando il modulo `PhoenixBricks.Scopes` è possibile estendere il comportament
  di un modulo aggiungendo le funzionalità relativa al componimento dei queries

  ```elixir
  defmodule RecordQuery do
    use PhoenixBricks.Scopes, schema: RecordSchema

    defp apply_scope(query, {:title_matches, "value"}) do
      query
      |> where([q], ...)
    end
  end
  ```

  ## Filter
  Un'altra funzionalità frequente è quella di ricevere tramite `query_params`
  un elenco di possibili filtri da applicare alla collection.
  ```elixir
  def index(conn, params)
    filters = Map.get(params, "filters", %{})

    colletion = Context.list_records_based_on_filters(filters)

    conn
    |> assign(:collection, collection)
    ...
  end
  ```
  assicurandoci di fornire solamente gli scopes che l'utente ha il permesso di
  utilizzare tramite form.

  Una possibile implementazione potrebbe essere
  ```elixir
  defmodule RecordFilter do
    @search_filters ["title_matches", "price_lte"]

    def convert_filters_to_scopes(filters) do
      filters
      |> Enum.map(fn {name, value} ->
        convert_filter_to_scope(name, value)
      end)
    end

    def convert_filter_to_scope(name, value) when name in @search_fields do
      {String.to_atom(name), value}
    end
  end
  ```

  In questo modo i parametri vengono rimappati in una lista comprensibile al
  modulo per la composizione degli scopes:
  ```elixir
  iex> RecordFilter.convert_filters_to_scopes(%{"title_matches" => "value", "invalid_scope" => "value"})
  iex> [title_matches: "value"]
  ```

  cosi facendo possiamo riscrivere l'action come
  ```elixir
  def index(conn, params) do
    filters = Map.get(params, "filters", %{})

    collection =
      filters
      |> RecordFilter.convert_filters_to_scopes()
      |> Context.list_records()

    conn
    |> assign(:collection, collection)
    ....
  end
  ```

  A questo punto rimane il problema della creazione del form. Per semplificarne
  la gestione si può definire `RecordFilter` come schema:
  ```elixir
  defmodule RecordFilter do
    use Ecto.Schema

    embedded_schema do
      field :title_matches, :string
    end

    def changeset(filter, params) do
      filter
      |> cast(params, [:title_matches])
    end
  end

  def index(conn, params) do
    filters = Map.get(params, "filters", %{})
    filter_changeset = RecordFilter.changeset(%RecordFilter{}, filters)

    collection =
      filters
      |> RecordFilter.convert_filters_to_scopes()
      |> Context.list_records()

    conn
    |> assign(:collection, collection)
    |> assign(:filter_changeset, filter_changeset)
  end
  ```

  ```html
    <%= f = form_for @filter_changeset, .... %>
      <%= label f, :title_matches %>
      <%= text_input f, :title_matches %>

      <%= submit "Filter results" %>
    <% end %>
  ```

  ### modulo `PhoenixBricks.Filter`
  Usando il modulo `PhoenixBricks.Filter` è possibile estendere il comportamento
  di un modulo aggiungendo le funzionalità relative alla gestione del form
  di ricerca e conversione in scopes

  ```elixir
  defmodule RecordFilter do
    use PhoenixBricks.Filter,
        filters: [
          title_matches: :string
        ]
  end
  ```

  che rende disponibile un metodo `changeset/2` per comporre il form di ricerca
  e il metodo `convert_filters_to_scopes/1` per mappare i filter params.

  """
end
