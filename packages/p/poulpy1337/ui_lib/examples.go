package svg

import (
	svg "gno.land/r/poulpy1337/ui_lib/svg"

)

func dashboardCard() string {
	canvas := svg.NewSvgCanvas(160, 100, "0 0 160 100", 
		`.card { filter: drop-shadow(0 2px 8px rgba(0,0,0,0.1)); }
		 .card-title { font-family: Arial, sans-serif; font-size: 14px; font-weight: bold; text-anchor: middle; }
		 .card-value { font-family: Arial, sans-serif; font-size: 24px; font-weight: bold; text-anchor: middle; }
		 .card-label { font-family: Arial, sans-serif; font-size: 10px; text-anchor: middle; fill: #666; }`,
		
		svg.NewSvgRect(0, 0, 160, 100, 8, "white", "card"),
		svg.NewSvgText(80, 20, "Total Users", "black", "card-title"),
		svg.NewSvgText(80, 50, "12,847", "#4CAF50", "card-value"),
		svg.NewSvgText(80, 70, "+12% from last month", "green", "card-label"),
	)
	return getRenderSvg(canvas.Render())
}

func dataTableRow() string {
	canvas := svg.NewSvgCanvas(300, 40, "0 0 300 40",
		`.table-row { fill: white; stroke: #e0e0e0; stroke-width: 1; }
		 .table-row:hover { fill: #f5f5f5; }
		 .cell-text { font-family: Arial, sans-serif; font-size: 11px; }
		 .status-active { fill: #4CAF50; }
		 .status-text { font-family: Arial, sans-serif; font-size: 10px; font-weight: bold; text-anchor: middle; fill: white; }`,
		
		svg.NewSvgRect(0, 0, 300, 40, 0, "white", "table-row"),
		svg.NewSvgText(10, 25, "John Doe", "black", "cell-text"),
		svg.NewSvgText(80, 25, "john@example.com", "#666", "cell-text"),
		svg.NewSvgText(180, 25, "Admin", "black", "cell-text"),
		svg.NewSvgRect(230, 12, 50, 16, 8, "#4CAF50", "status-active"),
		svg.NewSvgText(255, 22, "Active", "white", "status-text"),
	)
	return getRenderSvg(canvas.Render())
}

func multiColorProgressBar() string {
	canvas := svg.NewSvgCanvas(300, 40, "0 0 300 40",
		`.progress-bg { fill: #f5f5f5; stroke: #ddd; stroke-width: 1; }
		 .progress-success { fill: #4CAF50; }
		 .progress-warning { fill: #FF9800; }
		 .progress-danger { fill: #F44336; }
		 .label { font-family: Arial, sans-serif; font-size: 11px; fill: #333; }`,
		
		// Label
		svg.NewSvgText(10, 15, "System Resources", "#333", "label"),
		
		// Background bar
		svg.NewSvgRect(10, 20, 250, 12, 0, "#f5f5f5", "progress-bg"),
		
		// Success portion (50%)
		svg.NewSvgRect(10, 20, 125, 12, 0, "#4CAF50", "progress-success"),
		// Warning portion (25%)
		svg.NewSvgRect(135, 20, 62, 12, 0, "#FF9800", "progress-warning"),
		// Danger portion (10%)
		svg.NewSvgRect(197, 20, 25, 12, 0, "#F44336", "progress-danger"),
		
		// Status text
		svg.NewSvgText(270, 28, "85%", "#333", "label"),
	)
	return getRenderSvg(canvas.Render())
}

func gameOfLifeFrame() string {
	canvas := svg.NewSvgCanvas(120, 120, "0 0 120 120",
		`.grid-bg { fill: #f5f5f5; stroke: #ddd; stroke-width: 1; }
		 .cell-alive { fill: #000; stroke: white; stroke-width: 1; }
		 .cell-dead { fill: white; stroke: #ddd; stroke-width: 1; }`,
		
		// Background
		svg.NewSvgRect(0, 0, 120, 120, 0, "#f5f5f5", "grid-bg"),
		
		// Dead cells (white squares)
		//row 1
		svg.NewSvgRect(0, 0, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(20, 0, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(40, 0, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(60, 0, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(80, 0, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(100, 0, 20, 20, 0, "white", "cell-dead"),
		
		//row 2
		svg.NewSvgRect(0, 20, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(20, 20, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(40, 20, 20, 20, 0, "", "cell-alive"), // ALIVE
		svg.NewSvgRect(60, 20, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(80, 20, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(100, 20, 20, 20, 0, "white", "cell-dead"),
		
		//row 3
		svg.NewSvgRect(0, 40, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(20, 40, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(40, 40, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(60, 40, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(80, 40, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(100, 40, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		
		//row 4
		svg.NewSvgRect(0, 60, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(20, 60, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(40, 60, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(60, 60, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(80, 60, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(100, 60, 20, 20, 0, "white", "cell-dead"),
		
		//row 5
		svg.NewSvgRect(0, 80, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(20, 80, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(40, 80, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(60, 80, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(80, 80, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(100, 80, 20, 20, 0, "white", "cell-dead"),
		
		//row 6
		svg.NewSvgRect(0, 100, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(20, 100, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(40, 100, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(60, 100, 20, 20, 0, "white", "cell-dead"),
		svg.NewSvgRect(80, 100, 20, 20, 0, "#2196F3", "cell-alive"), // ALIVE
		svg.NewSvgRect(100, 100, 20, 20, 0, "white", "cell-dead"),
	)
	return getRenderSvg(canvas.Render())
}


func steppedProgressBar() string {
	canvas := svg.NewSvgCanvas(300, 60, "0 0 300 60",
		`.step-complete { fill: #4CAF50; stroke: #388E3C; stroke-width: 2; }
		 .step-current { fill: #2196F3; stroke: #1976D2; stroke-width: 2; }
		 .step-pending { fill: #e0e0e0; stroke: #bdbdbd; stroke-width: 2; }
		 .step-text { font-family: Arial, sans-serif; font-size: 10px; text-anchor: middle; }
		 .step-label { font-family: Arial, sans-serif; font-size: 8px; text-anchor: middle; fill: #666; }
		 .connector { fill: #4CAF50; }
		 .connector-pending { fill: #e0e0e0; }`,
		
		// Step 1 (Complete)
		svg.NewSvgCircle(50, 25, 12, "#4CAF50", "step-complete"),
		svg.NewSvgText(50, 29, "1", "white", "step-text"),
		svg.NewSvgText(50, 45, "Login", "#333", "step-label"),
		
		// Connector 1-2 (Complete)
		svg.NewSvgRect(62, 23, 40, 4, 2, "#4CAF50", "connector"),
		
		// Step 2 (Complete)
		svg.NewSvgCircle(115, 25, 12, "#4CAF50", "step-complete"),
		svg.NewSvgText(115, 29, "2", "white", "step-text"),
		svg.NewSvgText(115, 45, "Details", "#333", "step-label"),
		
		// Connector 2-3 (Complete)
		svg.NewSvgRect(127, 23, 40, 4, 2, "#4CAF50", "connector"),
		
		// Step 3 (Current)
		svg.NewSvgCircle(180, 25, 12, "#2196F3", "step-current"),
		svg.NewSvgText(180, 29, "3", "white", "step-text"),
		svg.NewSvgText(180, 45, "Payment", "#333", "step-label"),
		
		// Connector 3-4 (Pending)
		svg.NewSvgRect(192, 23, 40, 4, 2, "#e0e0e0", "connector-pending"),
		
		// Step 4 (Pending)
		svg.NewSvgCircle(245, 25, 12, "#e0e0e0", "step-pending"),
		svg.NewSvgText(245, 29, "4", "#999", "step-text"),
		svg.NewSvgText(245, 45, "Confirm", "#666", "step-label"),
	)
	return getRenderSvg(canvas.Render())
}


