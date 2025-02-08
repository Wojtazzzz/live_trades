defmodule LiveTrades.TradingsTest do
  use LiveTrades.DataCase

  alias LiveTrades.Tradings

  describe "companies" do
    alias LiveTrades.Tradings.Company

    import LiveTrades.TradingsFixtures

    @invalid_attrs %{code: nil, name: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Tradings.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Tradings.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{code: "some code", name: "some name"}

      assert {:ok, %Company{} = company} = Tradings.create_company(valid_attrs)
      assert company.code == "some code"
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tradings.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name"}

      assert {:ok, %Company{} = company} = Tradings.update_company(company, update_attrs)
      assert company.code == "some updated code"
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Tradings.update_company(company, @invalid_attrs)
      assert company == Tradings.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Tradings.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Tradings.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Tradings.change_company(company)
    end
  end
end
