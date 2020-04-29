class ContestDetails{
  ContestDetails({
    this.contestID,
    this.backgroundURL,
    this.contestNumber,
    this.contestTitle,

    this.empty,

  });

  final String contestID;
  final String backgroundURL;
  final int contestNumber;
  final String contestTitle;

  final Null empty;



  factory ContestDetails.fromMap(Map<String, dynamic> data, String documentID){
    if(data == null){
      return null;
    }
    final String contestID = documentID;

    final String backgroundURL = data['background_url'];
    final int contestNumber = data['contest_number'];
    final String contestTitle = data['contest_title'];

    final Null empty = data['empty'];


    return ContestDetails(
      contestID: contestID,
      backgroundURL: backgroundURL,
      contestNumber: contestNumber,
      contestTitle: contestTitle,
      empty: empty,

    );
  }

  Map<String, dynamic> toMap(){
    return {
      contestID != null ? 'user_id': 'empty' : contestID,
      backgroundURL != null ? 'username': 'empty' : backgroundURL,
      contestNumber != null ? 'gender': 'empty' : contestNumber,
      contestTitle != null ? 'date_of_birth': 'empty' : contestTitle,

    };
  }

}