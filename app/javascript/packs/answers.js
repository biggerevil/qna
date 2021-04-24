$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })

    $('form.new-answer').on('ajax:success', function(e) {
        let xhr = e.detail[2];

        $('.answers').append(xhr.responseText);
        $('.answer-errors').val('');
        $('.new-answer #answer_body').val('');
        $('.new-answer #answer_files').val('');
        $('.new-answer #answer_links_attributes_0_name').val('');
        $('.new-answer #answer_links_attributes_0_url').val('');
    })
        .on('ajax:error', function(e) {
            let xhr = e.detail[2];

            $('.answer-errors').html(xhr.responseText);
        })
});