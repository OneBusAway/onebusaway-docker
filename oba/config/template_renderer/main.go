package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"

	"github.com/mailgun/raymond/v2"
)

func renderTemplate(templatePath, jsonString string) (string, error) {
	// Read the contents of the template file
	templateContents, err := os.ReadFile(templatePath)
	if err != nil {
		return "", fmt.Errorf("error reading template file: %v", err)
	}

	// Parse the JSON string into a map
	var jsonData map[string]interface{}
	err = json.Unmarshal([]byte(jsonString), &jsonData)
	if err != nil {
		return "", fmt.Errorf("error parsing JSON: %v", err)
	}

	// Parse the template
	template, err := raymond.Parse(string(templateContents))
	if err != nil {
		return "", fmt.Errorf("error parsing template: %v", err)
	}

	// Render the template with the JSON data
	result, err := template.Exec(jsonData)
	if err != nil {
		return "", fmt.Errorf("error rendering template: %v", err)
	}

	return result, nil
}

func main() {
	inputFile := flag.String("input", "", "my-template.hbs")
	outputFile := flag.String("output", "", "my-output.html")
	jsonString := flag.String("json", "", `{"name": "John Doe"}`)

	// Parse the flags
	flag.Parse()

	if *inputFile == "" {
		fmt.Println("Error: input file is required")
		os.Exit(1)
	}

	if *jsonString == "" {
		fmt.Println("Error: JSON string is required")
		os.Exit(1)
	}

	// Render the template
	result, err := renderTemplate(*inputFile, *jsonString)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}

	if *outputFile != "" {
		os.WriteFile(*outputFile, []byte(result), 0644)
	} else {
		fmt.Println(result)
	}
}
