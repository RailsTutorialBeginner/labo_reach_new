// 一定時間ごとに新着メッセージを自動受信
// 現状10秒以内に両者が色々メッセージを送ると順番がバラバラに表示される。
// でも10秒以内にポンポンメッセージを送ることはそんなに無いと思うので、更新幅は10秒とする。
// あとからリダイレクトしたら、順番が変わることもある！

$(function(){
  function buildMESSAGE(message) {
    if(message.is_student){
      var messages = $('.messages:last').append('<div class="message student-message" data-id=' + message.id + '><div class="message-box"><div class="message-content"><div class="message-text">' + message.content + '</div></div></div></div><div class="clear"></div>');
    } else {
      var messages = $('.messages:last').append('<div class="message school-message" data-id=' + message.id + '><div class="message-box"><div class="message-content"><div class="message-text">' + message.content + '</div></div></div></div><div class="clear"></div>');
    }
  }

  $(function(){
    setInterval(update, 10000);
    //10000ミリ秒ごとにupdateという関数を実行する
  });
  function update(){ //この関数では以下のことを行う
    if($('.student-message')[0]){ //もし'messages'というクラスがあったら
      var student_message_id = $('.student-message:last').data('id'); //一番最後にある'messages'というクラスの'id'というデータ属性を取得し、'message_id'という変数に代入
    } else { //ない場合は
      var student_message_id = 0 //0を代入
    }
    if($('.school-message')[0]){ //もし'messages'というクラスがあったら
      var school_message_id = $('.school-message:last').data('id'); //一番最後にある'messages'というクラスの'id'というデータ属性を取得し、'message_id'という変数に代入
    } else { //ない場合は
      var school_message_id = 0 //0を代入
    }
    $.ajax({ //ajax通信で以下のことを行う
      url: location.href, //urlは現在のページを指定
      type: 'GET', //メソッドを指定
      data: { //railsに引き渡すデータは
        message: { student_id: student_message_id, school_id: school_message_id } //このような形(paramsの形をしています)で、'id'には'message_id'を入れる
      },
      dataType: 'json' //データはjson形式
    })
    .always(function(data){ //通信したら、成功しようがしまいが受け取ったデータ（@new_message)を引数にとって以下のことを行う
      $.each(data, function(i, data){ //'data'を'data'に代入してeachで回す
        buildMESSAGE(data); //buildMESSAGEを呼び出す
      });
    });
  }
});

// メッセージ送信時に非同期通信

$(document).on('turbolinks:load', function(){
  function buildHTML(message) {
    if(message.is_student){
      var html = '<div class="message student-message" data-id=' + message.id + '><div class="message-box"><div class="message-content"><div class="message-text">' + message.content + '</div></div></div></div><div class="clear"></div>';
    } else {
      var html = '<div class="message school-message" data-id=' + message.id + '><div class="message-box"><div class="message-content"><div class="message-text">' + message.content + '</div></div></div></div><div class="clear"></div>';
    }
  return html;
  }

  // なぜかうまく行かない！
  function scrollBottom(){
    var target = $('.messages').last();
    var position = target.offset().top + $('.messages').scrollTop();
    $('.messages').animate({
      scrollTop: position
    }, 300, 'swing');
  }

  $('#new_message').on('submit', function(e){
    e.preventDefault();
    var submit_message = new FormData(this);
    var url = location.href + "/messages";
    $.ajax({
      url: url,
      type: 'POST',
      data: submit_message,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.messages:last').append(html);
      $('#message_content').val(''); //input内のメッセージを消しています。
      scrollBottom();
    })
    .fail(function(data){
      alert('エラーが発生したためメッセージは送信できませんでした。');
    })
    .always(function(data){
      $('.submit-btn').prop('disabled', false); //ここで解除している
    })
  })
});
