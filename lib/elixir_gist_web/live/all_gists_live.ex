defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  alias ElixirGistWeb.Utilities.DateFormat

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    gists = Gists.list_gists()
    socket = assign(socket, gists: gists)
    {:noreply, socket}
  end

  def gist(assigns) do
    assigns =
      assigns
      |> assign(relative_time: DateFormat.get_relative_time(assigns.gist.updated_at))

    ~H"""
    <div class="border borde-white rounded-md pt-2 mb-6 shadow-sm shadow-white">
      <div>
        <div class="flex justify-between items-center px-2">
          <div class="flex items-center">
          <div class=" w-8 h-8 mr-1 flex items-center justify-center rounded-full border-[1px] border-emLavander">
            <img src="/images/user-image.svg" alt="" class=" w-4 h-4" />
          </div>
            <span class="font-bold">
          <%= @current_user.email %>
        </span>/
            <span class="text-emLavander"><%= @gist.name %></span>
          </div>
          <div class="flex items-center">

            <img src="/images/comment.svg" alt="" class="w-6 h-6 mr-1">
            <span class=" mr-2">0</span>
            <img src="/images/BookmarkOutline.svg" alt="" class="w-6 h-6 mr-1" >
            <span class="">0</span>
          </div>
        </div>
      </div>
      <div class="flex justify-between items-center">
      <div class="text-sm mt-4 text-emLavander-light px-2">
        <%= @gist.description %>
      </div>
      <div class="text-sm mt-4 text-white px-2"><%= @relative_time %></div>
      </div>

      <div class="mt-4 js-line-parent flex w-full" phx-update="ignore" id="gist-wrap" >
      <textarea readonly id={"syntax-numbers=#{@gist.id}"} class="syntax-numbers border-none"></textarea>
        <div
          id={"highlight-wrap=#{@gist.id}"}
          class="syntax-area w-full border-none"
          phx-hook="Highlight"
          data-name={@gist.name}
        >
            <pre>
            <code class="language-elixir">
              <%= get_preview_text(@gist) %>
            </code>
          </pre>
        </div>
      </div>
    </div>
    """
  end

  defp get_preview_text(gist) when not is_nil(gist.markup_text) do
    lines = String.split(gist.markup_text, "\n")
    if length(lines) > 10 do
      Enum.take(lines, 9) ++ ["..."] |> Enum.join("\n")
    else
      gist.markup_text
    end

  end

  defp get_preview_text(_gist), do: ""
end
