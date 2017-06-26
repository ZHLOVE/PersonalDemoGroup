# gitbook插件使用

##KaTex 公式插件

```
Inline math: $$\int_{-\infty}^\infty g(x) dx$$


Block math:

$$
\int_{-\infty}^\infty g(x) dx
$$

Or using the templating syntax:

{% math %}\int_{-\infty}^\infty g(x) dx{% endblock %}
```

Inline math: $$\int_{-\infty}^\infty g(x) dx$$


Block math:

$$
\int_{-\infty}^\infty g(x) dx
$$

Or using the templating syntax:

{% math %}\int_{-\infty}^\infty g(x) dx{% endblock %}

## exercise （当前测试没效果）
{% exercise %}
Define a variable `x` equal to 10.
{% initial %}
var x =
{% solution %}
var x = 10;
{% validation %}
assert(x == 10);
{% context %}
// This is context code available everywhere
// The user will be able to call magicFunc in his code
function magicFunc() {
    return 3;
}
{% endexercise %}

## Advanced Emoji (当前测试没效果)

<!-- ignore:advanced-emoji:start -->
:white_check_mark:
<!-- ignore:advanced-emoji:end -->

This is a text

<!-- ignore:advanced-emoji:start -->
'''
Check the Code
Code ... :white_check_mark:
'''
<!-- ignore:advanced-emoji:end -->

foo