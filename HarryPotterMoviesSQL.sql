select * from PortfolioProject.dbo.HPMovies

select * from PortfolioProject.dbo.HPDialogue

select * from PortfolioProject.dbo.HPChapters

select * from PortfolioProject.dbo.HPCharacters

select * from PortfolioProject.dbo.HPPlaces

select * from PortfolioProject.dbo.HPSpells



-- -- Which character has the most lines?

select distinct count(Dialogue) as NumLines, [Character ID]
from PortfolioProject.dbo.HPDialogue
join PortfolioProject.dbo.HPChapters
on PortfolioProject.dbo.HPDialogue.[Chapter ID] = PortfolioProject.dbo.HPChapters.[Chapter ID]
group by [Character ID]
order by count(Dialogue) desc


select [Character Name] 
from PortfolioProject.dbo.HPCharacters
where [Character ID] = 1


-- Which locations are most popular?

select distinct count([Place Category]) as NumPlaces, [Place Category]
from PortfolioProject.dbo.HPPlaces
group by [Place Category]
order by 1 desc



-- Which movie has the longest run time?

select [Movie Title] 
from PortfolioProject.dbo.HPMovies
group by [Movie Title], Runtime
having Runtime > 160

-- Which movie grossed the most?

select max([Box Office]) as MostGrossed, [Movie Title]
from PortfolioProject.dbo.HPMovies
group by [Movie Title]
order by MostGrossed desc

-- which movie had the biggest budget?

select max(Budget) as BigBudget, [Movie Title]
from PortfolioProject.dbo.HPMovies
group by [Movie Title]
order by BigBudget desc


 
-- Which wand core and wand wood are most common?

select max([Wand (Core)])
from PortfolioProject.dbo.HPCharacters

select max([Wand (Wood)])
from PortfolioProject.dbo.HPCharacters


--Which House do the characters belong to? and how diverse are the houses?

select distinct(House), 
count ([Character ID]) Total,
count (case 
when Gender='Male'
then [Character ID] end) Male,
count (case 
when Gender='Female'
then [Character ID] end) Female,
count (case 
when Gender not in ('Female','Male')
then [Character ID] end) Other
from PortfolioProject.dbo.HPCharacters 
where House is not null
group by House
order by Total desc

