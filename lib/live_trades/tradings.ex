defmodule LiveTrades.Tradings do
  @moduledoc """
  The Tradings context.
  """

  import Ecto.Query, warn: false
  alias LiveTrades.Tradings.Statistic
  alias LiveTrades.TradingClient
  alias LiveTrades.Repo

  alias LiveTrades.Tradings.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company by code.

  ## Examples

      iex> get_company(aapl)
      %Company{}

      iex> get_company(aapllll)
      ** nil

  """
  def get_company_by_code(code) do
    Company |> Ecto.Query.where(code: ^code) |> Repo.one()
  end

  def get_company_with_data(company_id) do
    company =
      Repo.one(
        from c in Company,
          where: c.id == ^company_id,
          preload: [
            statistics:
              ^from(s in Statistic,
                order_by: [desc: s.inserted_at],
                limit: 10
              )
          ]
      )

    case company do
      nil -> nil
      company -> company
    end
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  def get_company_current_data(code) do
    get_company_by_code(code)
    |> case do
      nil -> nil
      company -> TradingClient.fetch_company_data_by_code(company.code)
    end
  end
end
