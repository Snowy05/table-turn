// multi-select: List<String> in GameModel
// const List<String> allCategories = [
//   'Strategy',
//   'Family',
//   'Party',
//   'Cooperative',
//   'Card Game',
//   'Dice Game',
//   'Thematic',
//   'Eurogame',
//   'Ameritrash',
//   'Wargame',
//   'Miniatures',
//   'Role-Playing Game (RPG)',
//   'Trivia',
//   'Tile-Laying',
//   'Word Game',
// ];

// single-select: String in GameModel
const List<String> allComplexities = ['Easy', 'Medium', 'Hard', 'Expert'];

//single-select: String in GameModel
const List<String> allPlayTimes = [
  'Under 30 minutes',
  '30-60 minutes',
  '1-2 hours',
  'Over 2 hours',
];

//multi-select: List<String> in GameModel
const List<String> allTags = [
  'New',
  'Classic',
  'Family Favorite',
  'Strategy Game',
  'Party Game',
  'Cooperative Game',
  'Card Game',
  'Dice Game',
  'Word Game',
  'Trivia',
  'Drawing Game',
  'For Kids',
  'Long-Haul',
  'Roleplaying Game',
];

//single-select: String in GameModel
const List<String> allAvailabilityStatuses = [
  'Available',
  'Limited Stock',
  'Out of Stock',
];

//single-select: String in BookingModel (not GameModel)
const List<String> allBookingStatuses = ['Pending', 'Confirmed', 'Cancelled'];

//single-select: String in GameModel
const List<String> allAgeGroups = ['Kids', 'Teens', 'Adults', 'Family'];
