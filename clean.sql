select
trip_id,
cast(started_at as date) as started_at,
cast(ended_at as date) as ended_at,
time(timestamp_seconds(date_diff(ended_at, started_at, second))) as ride_length,
format_date('%a', date(started_at)) as day_of_week,
(case 
  when member_casual = "Customer" then "casual"
  when member_casual = "Subscriber" then "member"
  else member_casual
end) as member_casual
from first-milestone.divvy_tripdata.tripdata_union
where ended_at > started_at 
order by 4 desc
