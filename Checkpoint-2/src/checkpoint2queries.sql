--Checkpoint 2, Question 1: How much settlement costs do officers grouped by their common allegation cause?
select avg(total_settlement) as avg_cost,
       sum(total_settlement) as total_costs,
       most_common_complaint as common_complaints
from (
         select sum(total_settlement)      as total_settlement,
                most_common                as most_common_complaint
         from (
                  select max(category) as most_common, data_officerallegation.officer_id
                  from data_officerallegation
                           join data_allegationcategory da on data_officerallegation.allegation_category_id = da.id
                  group by data_officerallegation.officer_id
              )
                  as comm_cat_per_po
                  join (
             select *
             from lawsuit_lawsuit_officers
                      join lawsuit_lawsuit ll on lawsuit_lawsuit_officers.lawsuit_id = ll.id
         ) llo on llo.officer_id = comm_cat_per_po.officer_id
         group by comm_cat_per_po.officer_id, most_common
     ) as officer_costs
group by most_common_complaint;

--Checkpoint 2, Question 2: What is the average amount of disciplines per rank? What's the relationship between the two?
select avg(officer_count) as average,
       count(officer_count) as officers_disciplined,
       rank
from (
         select count(*) as officer_count, rank
         from data_officerallegation
                  inner join data_officer d on data_officerallegation.officer_id = d.id
         where disciplined = 'true'
         group by officer_id, rank
     )
        as officer_counts
group by rank;

--Checkpoint 3, Question 3: Is there a relationship between the number of awards and the number of disciplines per unit?
select sum(major_award_count),
       sum(discipline_count),
       last_unit_id
from data_officer
group by last_unit_id
order by last_unit_id;