com.isel.si1314.asi
===================
ISEL MEIC si1314 ASI Trabalho Final

===================
ToDo
	Relatorio
		Esquema Logico Global:
			Produto(Id[PK],IdFornecedor[FK],Codigo,Tipo,Designacao,Preco,QuantidadeStock,QuantidadeStockMin)
			Fornecedor(Id[PK],Numero,Nome,Morada)
			???? Tipo(Id[PK],Codigo,Nome) ????
		Esquema Fragmentacao
			Particao Vertical:
				ProdutoSede(Id[PK],IdFornecedor[FK],Codigo,Tipo,Designacao,Preco,QuantidadeStock,QuantidadeStockMin)
				ProdutoLojas(Id[PK],Codigo,Preco,QuantidadeStock)
			Particao Horizontal:
				ProdutoLojas1=SELECAO{tipo='CS'}(ProdutoLojas)
				ProdutoLojas2=SELECAO{tipo='HD'}(ProdutoLojas)

	QueueVendas.VendaServico.enviaVenda
		Console.Write("You entered: {0}", venda);//TODO: DELETE AFTER TESTES?
	ASIVesteSedeAppLayer.ISedeServico
        /// TODO: Comentarios
	ASIVesteSedeAppLayer.SedeServico
        //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
===================
