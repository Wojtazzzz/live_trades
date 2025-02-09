import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import ApexCharts from "apexcharts";

/**
 * @type {Object.<string, import("phoenix_live_view").ViewHook>}
 */
let Hooks = {};

let chart;

Hooks.Chart = {
	mounted() {
		const chartConfig = JSON.parse(this.el.dataset.config);
		const seriesData = JSON.parse(this.el.dataset.series);
		const categoriesData = JSON.parse(this.el.dataset.categories);

		const options = {
			chart: Object.assign(
				{
					background: "transparent",
				},
				chartConfig,
			),
			series: seriesData,
			xaxis: {
				categories: categoriesData,
			},
		};

		chart = new ApexCharts(this.el, options);

		chart.render();
	},
};

const csrfToken = document
	.querySelector("meta[name='csrf-token']")
	.getAttribute("content");

const liveSocket = new LiveSocket("/live", Socket, {
	longPollFallbackMs: 2500,
	params: { _csrf_token: csrfToken },
	hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

window.addEventListener("phx:new_data", (e) => {
	const data = e.detail;

	if (!data || !chart) {
		return;
	}

	chart.updateOptions({
		xaxis: {
			categories: data.categories,
		},
		series: data.dataset,
	});
});
