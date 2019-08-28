package main

import (
	"bufio"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"os"
	"regexp"
)

func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

type TableRow struct {
	Comment, Code, Stdout string
	Rowspan               int
	Class                 string
	Needtd                bool
}

type TableRows map[int]*TableRow

var t []*TableRow

func getLastRow() *TableRow {
	return t[len(t)-1]
}

func appendrow(class string) *TableRow {
	t = append(t, &TableRow{Class: class, Needtd: true, Rowspan: 1})
	return getLastRow()
}

func checkerr(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func getOut(d string, i int) string {
	ofilename := fmt.Sprintf("%s/%d.output.d", d, i)
	ofout, err := ioutil.ReadFile(ofilename)
	if err == nil {
		return string(ofout)
	}
	return "" //fmt.Sprintf("%d", i)
}
func main() {
	tmpl := template.Must(template.ParseFiles(os.Args[3]))

	var isComment = regexp.MustCompile(`^\s*//`)
	var isBlank = regexp.MustCompile(`^\s*$`)
	lines, err := readLines(os.Args[1])
	checkerr(err)

	var lastRow *TableRow
	var lastComment *TableRow

	for i, line := range lines {
		switch {
		case isBlank.MatchString(line):
			lastRow = appendrow("space")
			lastComment = lastRow
		case isComment.MatchString(line):
			if lastRow == nil || lastRow.Class != "withcomment" {
				lastRow = appendrow("withcomment")
				lastComment = lastRow
			}
			lastComment.Comment += isComment.ReplaceAllString(line, "")
		default:

			if lastRow == nil || lastRow.Class != "withcomment" {
				lastRow = appendrow("codeline")
			}
			lastRow.Code = line
			lastRow.Stdout = getOut(os.Args[2], i+1)
			if lastComment != nil && lastRow.Class != "withcomment" {
				lastComment.Rowspan = lastComment.Rowspan + 1
				lastRow.Needtd = false
			}
			lastRow.Class = "codeline"
		}

	}

	tmpl.Execute(os.Stdout, t)
}
