$('#action-placeholder').empty().append('Referenz anlegen')
$('#action-container').empty()
  .append('<%= j render partial: "referrals/form",
                        locals: { referral: @referral,
                                  item_selection: @item_selection,
                                  item: @item }%>')
$('.selectize').selectize({ plugins: ['remove_button'] })
$('input[id$="-selectized"]').css('width', '100%')
