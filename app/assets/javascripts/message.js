$(function(){
  function buildMESSAGE(message) {
    if(message.is_student){
      var messages = $('.chat-field').append('<div class="student-message messages" data-id=' + message.id + '>' + message.content + '</div>');
    } else {
      var messages = $('.chat-field').append('<div class="school-message messages" data-id=' + message.id + '>' + message.content + '</div>');
    }
    //'chat-field'にhtml全てをappendする
    // ただし、基本的にstudentかschoolかの識別ができていないので、なんとかする。
    console.log('build');
  }

  $(function(){
    setInterval(update, 10000);
    //10000ミリ秒ごとにupdateという関数を実行する
  });
  function update(){ //この関数では以下のことを行う
    console.log('hello');
    if($('.messages')[0]){ //もし'messages'というクラスがあったら
      var message_id = $('.messages:last').data('id'); //一番最後にある'messages'というクラスの'id'というデータ属性を取得し、'message_id'という変数に代入
      console.log('world');
    } else { //ない場合は
      var message_id = 0 //0を代入
    }
    console.log('here');
    $.ajax({ //ajax通信で以下のことを行う
      url: location.href, //urlは現在のページを指定
      type: 'GET', //メソッドを指定
      data: { //railsに引き渡すデータは
        message: { id: message_id } //このような形(paramsの形をしています)で、'id'には'message_id'を入れる
      },
      dataType: 'json' //データはjson形式
    })
    .always(function(data){ //通信したら、成功しようがしまいが受け取ったデータ（@new_message)を引数にとって以下のことを行う
      $.each(data, function(i, data){ //'data'を'data'に代入してeachで回す
        buildMESSAGE(data); //buildMESSAGEを呼び出す
        console.log('ajax');
      });
    });
  }
});
