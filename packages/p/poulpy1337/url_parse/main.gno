package main

type Arg struct {
	Name  string
	Value string
}

type Request struct {
	Args []Arg
	Page string
}



func Render(url string) string {
	return url
}
