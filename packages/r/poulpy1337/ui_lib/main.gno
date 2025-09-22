package svg

import (
	b64 "encoding/base64"
	svg "gno.land/r/poulpy1337/ui_lib/svg"

	"gno.land/p/demo/ufmt"
)

func getRenderSvg(svg string) string {
	sEnc := b64.StdEncoding.EncodeToString([]byte(svg))
	return ufmt.Sprintf("![%s](data:image/svg+xml;base64,%s)\n\n", "", sEnc)
}

func Render(args string) string {
	out := ""
	style := `
.small {
  font: italic 13px sans-serif;
}
.heavy {
  font: bold 30px sans-serif;
}

/* Note that the color of the text is set with the    *
 * fill property, the color property is for HTML only */
.Rrrrr {
  font: italic 40px serif;
  fill: red;
}
	`
	canvas1 := svg.NewSvgCanvas(250, 100, "0 0 250 100", style,
		svg.NewSvgText(20,35, "My", "black", "small"),
		svg.NewSvgText(40,35, "cat", "black", "heavy"),
		svg.NewSvgText(55,55, "is", "black", "small"),
		svg.NewSvgText(66,55, "Grumpy!", "red", "Rrrrr"),
	)
	out += "# ui_lib\n\n"
	out += "While playing with gno i felt the lack of widget, so i made that library who give back some element of customization.\n\nand to make gno applications more dynamic, possibility are endless.\n"
	out += "# Examples"
	out += getRenderSvg(canvas1.Render())
	out += "\n\n"
	out += dashboardCard()
	out += "\n\n"
	out += dataTableRow()
	out += "\n\n"
	out += gameOfLifeFrame()
	out += "\n\n"
	out += multiColorProgressBar()
	out += "\n\n"
	out += steppedProgressBar()
	return out
}
