package plugin

import (
	"github.com/prolix-oc/hwinfo-streamdeck/internal/hwinfo"
	hwsensorsservice "github.com/prolix-oc/hwinfo-streamdeck/pkg/service"
)

// Plugin implementation
type Plugin struct {
	Service *Service
}

// PollTime implementation for plugin
func (p *Plugin) PollTime() (uint64, error) {
	shmem, err := p.Service.Shmem()
	if err != nil {
		return 0, err
	}
	return shmem.PollTime(), nil
}

// Sensors implementation for plugin
func (p *Plugin) Sensors() ([]hwsensorsservice.Sensor, error) {
	shmem, err := p.Service.Shmem()
	if err != nil {
		return nil, err
	}
	var sensors []hwsensorsservice.Sensor
	for s := range shmem.IterSensors() {
		sensors = append(sensors, &sensor{s})
	}
	return sensors, nil
}

// ReadingsForSensorID implementation for plugin
func (p *Plugin) ReadingsForSensorID(id string) ([]hwsensorsservice.Reading, error) {
	res, err := p.Service.ReadingsBySensorID(id)
	if err != nil {
		return nil, err
	}
	var readings []hwsensorsservice.Reading
	for _, r := range res {
		readings = append(readings, &reading{r})
	}
	return readings, nil
}

type sensor struct {
	hwinfo.Sensor
}

func (s sensor) Name() string {
	return s.NameOrig()
}

type reading struct {
	hwinfo.Reading
}

func (r reading) Label() string {
	return r.LabelOrig()
}

func (r reading) Type() string {
	return r.Reading.Type().String()
}

func (r reading) TypeI() int32 {
	return int32(r.Reading.Type())
}
