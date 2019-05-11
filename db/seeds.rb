# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

MasterRole.delete_all
MasterRole.create([
				    {id:1, role:'user'},
				    {id:2, role:'admin'},
				    {id:3, role:'superadmin'}
				 ])

MasterUserStatus.delete_all
MasterUserStatus.create([
						  {id:1, status:'active'},
				          {id:2, status:'blocked'}
				       ])

MasterEventCategory.delete_all
MasterEventCategory.create([
						  {id:1, category:'Build'},
				          {id:2, category:'Learn'},
				          {id:3, category:'Meet'}
				       ])

MasterEventStatus.delete_all
MasterEventStatus.create([
						  {id:1, status:'pending'},
				          {id:2, status:'dismissed'},
				          {id:3, status:'active'},
				          {id:4, status:'deleted'},
				          {id:5, status:'completed'}
				       ])

messages_list = [
  [ "1", "Be sure to check out the HUK startup event series while you’re waiting!"],
  [ "2", "“Success is a lousy teacher. It seduces smart people into thinking they can’t lose” - Bill Gates" ],
  [ "3", "“Prefer the errors of enthusiasm to the indifference of wisdom” - someone young..." ],
  [ "4", "“Design is not (just) what it looks like and feels like. Design is (also) how it works” - Steve Jobs" ],
   [ "5", "“It is not the strongest of the species that survives, nor the most intelligent, but the ones most responsive to change” - Charles Darwin" ],
  [ "6", "“If there are nine rabbits on the ground and you want to catch one, just focus on one” - Jack Ma" ],
  [ "7", "“When you are small, you have to be very focused and rely on your brain, not your strength” - Jack Ma" ],
  [ "8", "“Everything should be made as simple as possible, but not simpler” - Albert Einstein" ],
   [ "9", "“Startups don’t win by attacking. They win by transcending” - Paul Graham" ],
  [ "10", "“Whenever you find yourself on the side of the majority, it is time to pause and reflect” - Mark Twain" ],
  [ "11", "“Our industry does not respect tradition. It only respects innovation” - Satya Nadella" ],
  [ "12", "“Fear is the disease. Hustle is the antidote” - Travis Kalanick" ],
   [ "13", "“Think of yourself as an insensitive, nitpicking, irritable fool to use the product” - Pony Ma" ],
  [ "14", "“‘Make something people want’ includes making a company people want to work for” - Sahil Lavingia" ],
  [ "15", "“Optimism, Pessimism, f**k that; we’re going to make it happen” - Elon Musk" ],
  [ "16", "“Attention to detail can’t be (and never is) added later. It’s an entire development philosophy, methodology and culture” - Marco Arment" ]
  
]

messages_list.each do |id, message|
  LoadingMessage.create( id: id, message: message )
end