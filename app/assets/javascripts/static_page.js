$(function() {
//（１）ページの概念・初期ページを設定
  var page=0;
  //（２）イメージの数を最後のページ数として変数化
  // var lastPage = parseInt($("#top-slide img").length-1);
  var lastPage = 3
  //（３）最初に全部のイメージを一旦非表示にします
  $("#top-slide img").css("display","none");

  //（４）初期ページを表示
  $("#top-slide img").eq(page).css("display","block");

  //（５）ページ切換用、自作関数作成
  function changePage(page){
    $("#top-slide img").fadeOut(1000);
    $("#top-slide img").eq(page).fadeIn(1000);
  };

  //（６）～秒間隔でイメージ切換の発火設定
  var Timer;
  function startTimer(){
    Timer = setInterval(function(){
      if(page === lastPage){
        page = 0;
        changePage(page);
      }else{
        page ++;
        changePage(page);
      };
    },5000);
  }
  //（７）～秒間隔でイメージ切換の停止設定
  // function stopTimer(){
  //   clearInterval(Timer);
  // }

  //（８）タイマースタート
  startTimer();

  /*オプションを足す場合はここへ記載*/
 });
