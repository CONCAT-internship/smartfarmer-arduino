// Package smartfarm defines sensor data model of smart farm
// and implements cloud functions for CRUD operations.
package smartfarm

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"cloud.google.com/go/firestore"
)

const projectID = "superfarmers"

// Insert inserts sensor data into Firestore.
func Insert(writer http.ResponseWriter, req *http.Request) {
	ctx := context.Background()

	client, err := firestore.NewClient(ctx, projectID)
	defer client.Close()
	if err != nil {
		fmt.Fprintf(writer, "firestore.NewClient: %v", err)
		return
	}

	var sensorData SensorData
	if err = json.NewDecoder(req.Body).Decode(&sensorData); err != nil {
		fmt.Fprintf(writer, "json.Decode: %v", err)
		return
	}
	sensorData.setTime()
	if err = sensorData.verify(); err != nil {
		fmt.Fprintf(writer, "verification failed: %v", err)
		return
	}

	if _, _, err = client.Collection("sensor_data").Add(ctx, sensorData); err != nil {
		fmt.Fprintf(writer, "insert: %v", err)
		return
	}
}
