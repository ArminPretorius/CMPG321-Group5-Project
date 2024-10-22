-- Location Sequence and Table Creation

CREATE SEQUENCE seq_Location
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE LOCATION(
    loc_id INT NOT NULL CONSTRAINT Location_PK PRIMARY KEY,
    loc_name VARCHAR(50),
    loc_latitude NUMBER(8,6) NOT NULL,
    loc_longitude NUMBER(8,6) NOT NULL,
    loc_city VARCHAR(50) NOT NULL,
    loc_province VARCHAR(50) NOT NULL,
    loc_country VARCHAR(50) NOT NULL,
    loc_postal VARCHAR(5) NOT NULL
);

-- Satellite View Sequence and Table Creation

CREATE SEQUENCE seq_SatelliteView
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE SATELLITE_VIEW(
    satellite_view_id INT NOT NULL CONSTRAINT SatelliteView_PK PRIMARY KEY,
    loc_id INT NOT NULL CONSTRAINT SatelliteView_Location_FK REFERENCES LOCATION(loc_id),
    satellite_view_url VARCHAR(100) NOT NULL
);

-- Street Sequence and Table Creation

CREATE SEQUENCE seq_Street
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE STREET(
    street_id INT NOT NULL CONSTRAINT Street_PK PRIMARY KEY,
    loc_id INT NOT NULL CONSTRAINT Street_Location_FK REFERENCES LOCATION(loc_id),
    street_name VARCHAR(50) NOT NULL
);

-- Street Segment Sequence and Table Creation

CREATE SEQUENCE seq_Segment
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE STREET_SEGMENT(
    segment_id INT NOT NULL CONSTRAINT Segment_PK PRIMARY KEY,
    street_id INT NOT NULL CONSTRAINT Segment_Street_FK REFERENCES STREET(street_id),
    segment_length NUMBER(8,3) NOT NULL,
    segment_direction NUMBER(8,3) NOT NULL,
    segment_road_type VARCHAR(50) NOT NULL,
    segment_start_loc_id INT NOT NULL CONSTRAINT Segment_StartLoc_FK REFERENCES LOCATION(loc_id),
    segment_end_loc_id INT NOT NULL CONSTRAINT Segment_EndLoc_FK REFERENCES LOCATION(loc_id)
);

-- Road Event Sequence and Table Creation

CREATE SEQUENCE seq_Event
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE ROAD_EVENT(
    event_id INT NOT NULL CONSTRAINT Event_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT Event_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    event_type VARCHAR(50) NOT NULL,
    event_description VARCHAR(100) NOT NULL,
    event_start_datetime DATE NOT NULL,
    event_end_datetime DATE NOT NULL
);

-- Public Transport Stop Sequence and Table Creation

CREATE SEQUENCE seq_PTStop
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE PUBLIC_TRANS_STOP(
    ptstop_id INT NOT NULL CONSTRAINT PTStop_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT PTStop_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    ptstop_name VARCHAR(50),
    ptstop_type VARCHAR(50) NOT NULL,
    ptstop_loc_id INT NOT NULL CONSTRAINT PTStop_Loc_FK REFERENCES LOCATION(loc_id)
);

-- Speed Limit Sequence and Table Creation

CREATE SEQUENCE seq_SpeedLimit
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE SPEED_LIMIT(
    slimit_id INT NOT NULL CONSTRAINT SLimit_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT SpeedLimit_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    slimit_value INT NOT NULL,
    slimit_start_time DATE,
    slimit_end_time DATE
);

-- Road Object Sequence and Table Creation

CREATE SEQUENCE seq_RoadObject
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE ROAD_OBJECT(
    object_id INT NOT NULL CONSTRAINT Object_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT Object_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    object_type VARCHAR(50) NOT NULL,
    object_description VARCHAR(100) NOT NULL,
    object_loc_id INT NOT NULL CONSTRAINT Object_Loc_FK REFERENCES LOCATION(loc_id)
);

-- Congestion Level Sequence and Table Creation

CREATE SEQUENCE seq_Congestion
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE CONGESTION_LEVEL(
    congestion_id INT NOT NULL CONSTRAINT Congestion_PK PRIMARY KEY,
    congestion_type VARCHAR(50) NOT NULL,
    congestion_description VARCHAR(100) NOT NULL
);

-- Live Traffic Data Sequence and Table Creation

CREATE SEQUENCE seq_TrafficData
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE LIVE_TRAFFIC_DATA(
    tdata_id INT NOT NULL CONSTRAINT TData_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT TData_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    congestion_id INT NOT NULL CONSTRAINT TData_Congestion_FK REFERENCES CONGESTION_LEVEL(congestion_id),
    tdata_datetime DATE NOT NULL,
    tdata_average_speed NUMBER(8,3) NOT NULL,
    tdata_traffic_volume INT NOT NULL,
    tdata_live_travel_time NUMBER(8,3) NOT NULL
);

-- Traffic Data Predictor Sequence and Table Creation

CREATE SEQUENCE seq_TrafficPred
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE TRAFFIC_DATA_PREDICTOR(
    predictor_id INT NOT NULL CONSTRAINT TDataPred_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT TDataPred_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    predictor_day_of_week INT NOT NULL,
    predictor_hour_of_day INT NOT NULL,
    predictor_travel_time NUMBER(8,3) NOT NULL,
    predictor_speed NUMBER(8,3) NOT NULL
);

-- Traffic Condition Sequence and Table Creation

CREATE SEQUENCE seq_TrafficCond
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE TRAFFIC_CONDITION(
    traf_cond_id INT NOT NULL CONSTRAINT TrafCond_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT TrafCond_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    traf_cond_type VARCHAR(50) NOT NULL,
    traf_cond_description VARCHAR(100) NOT NULL,
    traf_cond_start_datetime DATE NOT NULL,
    traf_cond_end_datetime DATE
);

-- Street View Sequence and Table Creation

CREATE SEQUENCE seq_StreetView
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE STREET_VIEW(
    street_view_id INT NOT NULL CONSTRAINT StreetView_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT StreetView_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    street_view_url VARCHAR(100) NOT NULL
);

-- Road Condition Sequence and Table Creation

CREATE SEQUENCE seq_RoadCond
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE ROAD_CONDITION(
    road_cond_id INT NOT NULL CONSTRAINT RoadCond_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT RoadCond_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    road_cond_type VARCHAR(50) NOT NULL,
    road_cond_description VARCHAR(100) NOT NULL,
    road_cond_start_datetime DATE NOT NULL,
    road_cond_end_datetime DATE
);

-- Point of Interest Sequence and Table Creation

CREATE SEQUENCE seq_POI
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE POINT_OF_INTEREST(
    poi_id INT NOT NULL CONSTRAINT POI_PK PRIMARY KEY,
    street_id INT NOT NULL CONSTRAINT POI_Street_FK REFERENCES STREET(street_id),
    poi_name VARCHAR(50) NOT NULL,
    poi_description VARCHAR(100) NOT NULL,
    poi_category VARCHAR(50) NOT NULL,
    poi_loc_id INT NOT NULL CONSTRAINT POI_Loc_FK REFERENCES LOCATION(loc_id)
);

-- Intersection Sequence and Table Creation

CREATE SEQUENCE seq_Intersection
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE INTERSECTION(
    intersection_id INT NOT NULL CONSTRAINT Intersection_PK PRIMARY KEY,
    first_street_id INT NOT NULL CONSTRAINT Intersection_FirstStreet_FK REFERENCES STREET(street_id),
    second_street_id INT NOT NULL CONSTRAINT Intersection_SecondStreet_FK REFERENCES STREET(street_id),
    intersection_loc_id INT NOT NULL CONSTRAINT Intersection_Loc_FK REFERENCES LOCATION(loc_id)
);

-- Intersecting Segments Table Creation

CREATE TABLE INTERSECTING_SEGMENTS(
    segment_id INT NOT NULL CONSTRAINT Intersecting_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    intersection_start_id INT NOT NULL CONSTRAINT Intersecting_Start_FK REFERENCES INTERSECTION(intersection_id),
    intersection_end_id INT NOT NULL CONSTRAINT Intersecting_End_FK REFERENCES INTERSECTION(intersection_id),
    CONSTRAINT Intersecting_PK PRIMARY KEY (segment_id, intersection_start_id, intersection_end_id)
);

-- Pedestrian Walkway Sequence and Table Creation

CREATE SEQUENCE seq_PedestrianWalkway
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE PEDESTRIAN_WALKWAY(
    walkway_id INT NOT NULL CONSTRAINT Walkway_PK PRIMARY KEY,
    segment_id INT NOT NULL CONSTRAINT Walkway_Segment_FK REFERENCES STREET_SEGMENT(segment_id),
    walkway_type VARCHAR(50) NOT NULL,
    walkway_width NUMBER(8,3) NOT NULL,
    walkway_accessibility VARCHAR(50) NOT NULL,
    walkway_surface VARCHAR(50) NOT NULL
);

-- Pedestrian Crossing Sequence and Table Creation

CREATE SEQUENCE seq_PedestrianCrossing
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE PEDESTRIAN_CROSSING(
    crossing_id INT NOT NULL CONSTRAINT Crossing_PK PRIMARY KEY,
    intersection_id INT NOT NULL CONSTRAINT PedCross_Intersection_FK REFERENCES INTERSECTION(intersection_id),
    crossing_type VARCHAR(50) NOT NULL,
    crossing_lights VARCHAR(50),
    crossing_signal VARCHAR(50)
);

-- Pedestrian Data Sequence and Table Creation

CREATE SEQUENCE seq_PedestrianData
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE PEDESTRIAN_DATA(
    pdata_id INT NOT NULL CONSTRAINT PData_PK PRIMARY KEY,
    walkway_id INT NOT NULL CONSTRAINT PData_Walkway_FK REFERENCES PEDESTRIAN_WALKWAY(walkway_id),
    pdata_datetime DATE NOT NULL,
    pdata_average_speed NUMBER(8,3) NOT NULL,
    pdata_pedestrian_volume INT NOT NULL,
    pdata_congestion_level INT NOT NULL
);