package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"github.com/MaestroError/go-libheif"
	"github.com/sqweek/dialog"
)

const (
	HEIC_EXTENSION = ".heic"
	JPG_EXTENSION  = ".jpg"
)

func main() {
	fmt.Println("HEIC to JPG Converter")

	currentDir, _ := os.Getwd()
	// Open a dialog to select a file or folder
	var path string
	path, err := dialog.Directory().SetStartDir(currentDir).Title("Choisir un dossier ou un fichier HEIC").Browse()
	if err != nil {
		fmt.Println("Error selecting file:", err)
		return
	}

	files, err := getHEICFiles(path)

	if err != nil {
		fmt.Println("Erreur lors de la récupération des fichiers HEIC")
		fmt.Println(err)
		return
	}

	processFiles(files)
}

func processFiles(files []string) {
	var wg sync.WaitGroup
	sem := make(chan struct{}, 2) // Buffered channel to limit concurrency

	for _, file := range files {
		wg.Add(1)         // Increment the WaitGroup counter
		sem <- struct{}{} // Acquire a token
		go func(f string) {
			defer wg.Done()          // Decrement the counter when the goroutine completes
			defer func() { <-sem }() // Release the token
			fmt.Printf("Converting file: %v\n", f)
			if err := convertHEICToJPG(f); err != nil {
				fmt.Println(err)
			}
		}(file)
	}

	wg.Wait() // Wait for all goroutines to finish
	fmt.Println("All conversions completed.")
}

/*
getHEICFiles : Takes a path and returns an array of .heic file paths
If the path is a directory, it recursively searches for .heic files
If the path is a .heic file, it returns an array with just that file
If the path is not a directory or a .heic file, it returns an error

@param filesChan: chan string
@param path: string
@return error
*/
func getHEICFiles(path string) ([]string, error) {
	// Check if path exists
	fileInfo, err := os.Stat(path)

	if err != nil {
		return nil, fmt.Errorf("impossible d'accéder au chemin : %v", path)
	}

	if !fileInfo.IsDir() {
		if !strings.HasSuffix(strings.ToLower(path), HEIC_EXTENSION) {
			return nil, fmt.Errorf("le fichier n'est pas un fichier '.heic' : %v", path)
		}
		return []string{path}, nil
	}

	fmt.Printf("Getting HEIC files dir '%v'\n", path)

	files := []string{}

	// If it's a directory, walk through it recursively
	err = filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		// Check if it's a file and has .heic extension
		if !info.IsDir() && strings.HasSuffix(strings.ToLower(path), HEIC_EXTENSION) {
			files = append(files, path)
		}
		return nil
	})

	if err != nil {
		return nil, fmt.Errorf("erreur lors du parcours du dossier : %v", path)
	}

	return files, nil
}

/*
convertHEICToJPG : Converts a .heic file to a .jpg file

@param heicFilePath: string
@return string, error
*/
func convertHEICToJPG(heicFilePath string) error {
	jpgFilePath := strings.Replace(heicFilePath, ".heic", ".jpg", 1)

	err := libheif.HeifToJpeg(heicFilePath, jpgFilePath, 100)

	if err != nil {
		return fmt.Errorf("error converting %v to JPG: %v", heicFilePath, err)
	}

	fmt.Println("Fichier JPG converti avec succès:", jpgFilePath)
	return nil
}
