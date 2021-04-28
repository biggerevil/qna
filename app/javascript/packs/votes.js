$(document).on('turbolinks:load', function() {
    $('.vote_link').on('ajax:success', function (e) {
        console.log(e);

        let data = e.detail[0];
        let id = data.id;
        let model_name = data.model_name;
        let rating = data.rating;
        let has_vote = data.has_vote;

        let votable_votes_stuff = $('#' + model_name + '-' + id + '-votes');
        votable_votes_stuff.find('.rating').html(rating);

        let votable_links_for_votes = votable_votes_stuff.find('.links_for_voting');

        if (has_vote) {
            votable_links_for_votes.find('.upvote_link').addClass("hidden");
            votable_links_for_votes.find('.downvote_link').addClass("hidden");
            votable_links_for_votes.find('.cancel_vote_link').removeClass("hidden");
        } else {
            votable_links_for_votes.find('.upvote_link').removeClass("hidden");
            votable_links_for_votes.find('.downvote_link').removeClass("hidden");
            votable_links_for_votes.find('.cancel_vote_link').addClass("hidden");
        }
    })
        .on('ajax:error', function (e) {
            let data = e.detail[0];
            let id = data.id;
            let model_name = data.model_name;
            let errors = data.errors;

            let div_for_votes_errors = $('#' + model_name + '-' + id + '-votes-errors');
            div_for_votes_errors.html("<b>Vote errors:</b>");
            $.each(errors, function(index, value) {
                div_for_votes_errors.append('<p>' + value + '</p>');
            })
        })
});