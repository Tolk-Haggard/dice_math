#!/usr/bin/env escript

main([Die1Str, Die2Str, Die3Str, Die4Str]) ->

    Die1 = list_to_integer(Die1Str),
    Die2 = list_to_integer(Die2Str),
    Die3 = list_to_integer(Die3Str),
    Die4 = list_to_integer(Die4Str),


    EmptyFun = fun(Val1, _Ignore) ->
                   Val1
               end,

    FunList = create_fun_list(),

    DiePermutations = perms([Die1, Die2, Die3, Die4]),

    Permutations = [[{DieA, EmptyFun}, {DieB, Fun1}, {DieC, Fun2}, {DieD, Fun3}] ||
                      [DieA, DieB, DieC, DieD] <- DiePermutations,
                      Fun1 <- FunList,
                      Fun2 <- FunList,
                      Fun3 <- FunList],
    
    AllResults = lists:map(fun(PermList) ->
                    lists:foldl(fun({Die, Fun}, Acc) ->
                                    Fun(Die, Acc)
                                end,
                                0,
                                PermList)
                 end,
                 Permutations),
    
    Result = apply_range(AllResults, []),
    FinalList = lists:delete(divide_error, lists:usort(Result)),

    io:format("Results: ~p~n", [FinalList]);
    

main(_Other) ->
    io:format("Usage is dice_math.escript Die1 Die2 Die3 Die4~n").

apply_range([], Acc) ->
    Acc;
apply_range([H|T], Acc) when H > 0 andalso H < 101 ->
    apply_range(T, [H|Acc]);
apply_range([_H|T], Acc) ->
    apply_range(T, Acc).


create_fun_list() ->

    AdditionFun = fun(_Ignore, divide_error) ->
                        divide_error;
                     (Addend1, Addend2) ->
                        Addend1 + Addend2
                  end,

    MultiplicationFun = fun(_Ignore, divide_error) ->
                            divide_error;
                        (Factor1, Factor2) ->
                            Factor1 * Factor2
                        end,

    MinuendFun = fun(_Ignore, divide_error) ->
                        divide_error;
                    (Minuend, Subtrahend) ->
                        Minuend - Subtrahend
                 end,

    SubtrahendFun = fun(_Ignore, divide_error) ->
                        divide_error;
                     (Subtrahend, Minuend) ->
                        Minuend - Subtrahend
                    end,

    DividendFun = fun(_Ignore, divide_error) ->
                        divide_error;
                     (Dividend, Divisor) ->
                        division(Dividend, Divisor)
                  end,

    DivisorFun = fun(_Ignore, divide_error) ->
                       divide_error;
                    (Divisor, Dividend) ->
                       division(Dividend, Divisor)
                 end,

    [AdditionFun, MultiplicationFun, 
     MinuendFun, SubtrahendFun, 
     DividendFun, DivisorFun].

division(_Ignored, 0) ->
        divide_error;
division(Dividend, Divisor) ->
    case (Dividend rem Divisor) of
        0 -> Dividend div Divisor;
        _ -> divide_error
    end.

perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].    
