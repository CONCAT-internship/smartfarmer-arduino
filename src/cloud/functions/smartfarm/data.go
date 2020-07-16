// Package smartfarm defines sensor data model of smart farm
// and implements cloud functions for CRUD operations.
package smartfarm

import "time"

// SensorData represents a single document of smartfarm sensor data collection.
type SensorData struct {
	UUID                   string    `json:"uuid"`
	LiquidTemperature      float64   `json:"liquid_temperature"`
	Temperature            float64   `json:"temperature"`
	Humidity               float64   `json:"humidity"`
	LiquidFlowRate         float64   `json:"liquid_flow_rate"`
	PH                     float64   `json:"ph"`
	ElectricalConductivity float64   `json:"ec"`
	LiquidLevel            bool      `json:"liquid_level"`
	Valve                  bool      `json:"valve"`
	LED                    bool      `json:"led"`
	Fan                    bool      `json:"fan"`
	UnixTime               int64     `json:"unix_time"`
	LocalTime              time.Time `json:"local_time"`
}

// setTime sets the time of sensor data.
func (s *SensorData) setTime() {
	s.LocalTime = time.Now()
	s.UnixTime = s.LocalTime.Unix()
}

// verify verifies that there are any unusual values in sensor data.
func (s SensorData) verify() error {
	// TODO: check whether sensor data is ordinary or not
	return nil
}
