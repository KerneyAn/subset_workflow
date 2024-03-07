# Define your increment step and the maximum number of reads (in millions)
INCREMENT_STEP = 5  # Increment by 5 million reads
MAX_READS = 15  # Maximum of 20 million reads

# Generate increments based on the step
increments = list(range(1, MAX_READS + 1, INCREMENT_STEP))

# Define your input files
READ1 = "/home/kerney/wolb-recomb/simulations/testing_6_genome/simulated_reads/sim.bwa.read1.fastq.gz"
READ2 = "/home/kerney/wolb-recomb/simulations/testing_6_genome/simulated_reads/sim.bwa.read2.fastq.gz"

rule all:
    input:
        expand("subsets/read1_{n}m.fq", n=increments),
        expand("subsets/read2_{n}m.fq", n=increments)

rule subset_reads:
    output:
        read1 = "subsets/read1_{n}m.fq",
        read2 = "subsets/read2_{n}m.fq"
    params:
        n = lambda wildcards: int(wildcards.n) * 1000000  # Convert millions to actual count
    shell:
        """
        seqtk sample -s100 {READ1} {params.n} > {output.read1}
        seqtk sample -s100 {READ2} {params.n} > {output.read2}
        """
