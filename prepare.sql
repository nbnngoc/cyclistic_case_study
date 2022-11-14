(
select
ride_id as trip_id,
started_at,
ended_at,
member_casual
from first-milestone.divvy_tripdata.tripdata_2020_q1
)
union all
(
select 
cast(trip_id as string) as trip_id,
start_time as started_at,
end_time as ended_at,
usertype as member_casual
from first-milestone.divvy_tripdata.tripdata_2019_q4
)
