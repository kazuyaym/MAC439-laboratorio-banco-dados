Podemos modelar a prescrição de um medicamento para um cliente por um médico de duas formas:
1) considerando que nem toda consulta gera uma prescrição (um modelo mais genérico)
2) considerando que, no contexto de farmácias, toda consulta obrigatoriamente tem uma prescrição com um medicamento, cliente e médico.

Devemos sempre pensar em como vamos recuperar as informações no sistema ao modelas as entidades.
Um medicamento pode ser fabricado por mais de um laboratório. Poderíamos utilizar um atributo multivalorado mas não seria possível identificar os medicamentos de um laboratório específico, por exemplo, para remover um lote do estoque.
A mesma ideia é aplicada a efeitos, sejam colaterais ou indicados. Se eles não fossem um tipo de entidade, não seria possível agrupar todos os medicamentos que causam o mesmo efeito.
