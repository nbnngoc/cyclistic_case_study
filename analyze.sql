select
day_of_week,
count(day_of_week) as freq
from first-milestone.divvy_tripdata.tripdata_cleaned
group by 1
order by 2 desc
limit 1

select
time(timestamp_seconds(max(time_diff(time(ride_length), '00:00:00', second)))) as max_ride_length,
time(timestamp_seconds(cast(round(avg(time_diff(time(ride_length), '00:00:00', second)), 0) as int))) as avg_ride_length
from first-milestone.divvy_tripdata.tripdata_cleaned
order by 1

select
member_casual,
time(timestamp_seconds(cast(round(avg(time_diff(time(ride_length), '00:00:00', second)), 0) as int))) as avg_ride_length
from first-milestone.divvy_tripdata.tripdata_cleaned
group by 1

select
day_of_week,
time(timestamp_seconds(cast(round(avg(time_diff(time(ride_length), '00:00:00', second)), 0) as int))) as avg_ride_length
from first-milestone.divvy_tripdata.tripdata_cleaned
group by 1

select
day_of_week,
count(trip_id) as num_of_rides
from first-milestone.divvy_tripdata.tripdata_cleaned
group by 1
order by 2 desc
