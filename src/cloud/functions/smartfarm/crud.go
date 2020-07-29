// Package smartfarm defines sensor data model of smart farm
// and implements cloud functions for CRUD operations.
package smartfarm

// [Start smart_farm_dependencies]
import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"cloud.google.com/go/firestore"
)

// [End smart_farm_dependencies]

const projectID = "superfarmers"

// [Start smart_farm_insert]

// Insert inserts sensor data into Firestore.
func Insert(writer http.ResponseWriter, req *http.Request) {
	ctx := context.Background()

	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		fmt.Fprintf(writer, "firestore.NewClient: %v", err)
		return
	}
	defer client.Close()

	var sensorData SensorData
	if err = json.NewDecoder(req.Body).Decode(&sensorData); err != nil {
		fmt.Fprintf(writer, "json.Decode: %v", err)
		return
	}
	// update creation time of sensor data
	sensorData.setTime()

	// check whether sensor data is usual or not
	if err = sensorData.verify(); err != nil {
		fmt.Fprintf(writer, "verification failed: %v", err)
		return
	}

	// store into collection
	if _, _, err = client.Collection("sensor_data").Add(ctx, sensorData); err != nil {
		fmt.Fprintf(writer, "insert: %v", err)
		return
	}
}

// [End smart_farm_insert]

// [Start smart_farm_get]

// Get gets documents from Firestore with given query.
func Get(writer http.ResponseWriter, req *http.Request) {
	ctx := context.Background()

	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		fmt.Fprintf(writer, "firestore.NewClient: %v", err)
		return
	}
	defer client.Close()

	// TODO: define query format, get from collection
}

// [End smart_farm_get]
