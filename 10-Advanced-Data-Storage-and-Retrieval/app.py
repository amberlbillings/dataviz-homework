# Amber Billings

from flask import Flask, jsonify
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, inspect, func

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

Base = automap_base()

Base.prepare(engine, reflect=True)

Measurement = Base.classes.measurement
Station = Base.classes.station

session = Session(engine)

app = Flask(__name__)

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/><br/>"
        f"/api/v1.0/precipitation<br/>"
        f"Returns a dictionary of dates and precipitation measures from the dataset.<br/><br/>"
        f"/api/v1.0/stations<br/>"
        f"Returns a list of stations from the dataset.<br/><br/>"
        f"/api/v1.0/tobs <br />"
        f"Returns a list of temperature observations from the previous year.<br/><br/>"
        f"/api/v1.0/&lt;start&gt; <br />"
        f"Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start.<br/><br/>"
        f"/api/v1.0/&lt;start&gt;/&lt;end&gt; <br />"
        f"Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start-end range.<br/><br/>"
        f"Date format: YYYY-MM-DD"
    )

@app.route("/api/v1.0/precipitation")
def precipitation():
    results = session.query(Measurement.date, Measurement.prcp).\
    filter(Measurement.date > '2016-08-22').\
    order_by(Measurement.date.desc()).all()

    precipitation = dict(results)

    return jsonify(precipitation)

@app.route("/api/v1.0/stations")
def stations():
    results = session.query(Station.station).all()
    
    stations = list(results)
    
    return jsonify(results)

@app.route("/api/v1.0/tobs")
def tobs():
    results = session.query(Measurement.tobs).\
    filter(Measurement.date > '2016-08-22').all()
    
    tobs = list(results)
    
    return jsonify(tobs)

@app.route("/api/v1.0/<start_date>")
def start_temps(start_date):
    results = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= startDate).all()
    return jsonify(results)

@app.route("/api/v1.0/<start_date>/<end_date>")
def start_end_temps(start_date, end_date):
    results = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= start_date).\
        filter(Measurement.date <= end_date).all()
    return jsonify(results)

if __name__ == "__main__":
    app.run(debug=True)